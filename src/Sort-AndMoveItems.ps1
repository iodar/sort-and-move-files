[CmdletBinding()]
param (
    # the source folder to include files from
    [Parameter()]
    [string]
    $SourceFolder,
    # the target folder where the files should get moved to
    [Parameter()]
    [string]
    $TargetFolder,
    [Parameter()]
    [ValidateSet("DateString", "FileName")]
    $GroupType,
    [Parameter()]
    [Switch]
    $CopyMode
    # TODO: 2020-06-04 dgr parameter will be added later
    # custom postfix to append to folder names
    # [Parameter()]
    # [string]
    # $CustomPostfix
)

# GLOBALS
$scripName = $MyInvocation.MyCommand.Name

function Get-AllElementsRecurse {
    param(
        [string] $Path
    )

    return Get-ChildItem -Path $Path -Recurse -Exclude "$scripName"
}

function Get-GroupsAndFiles {
    param (
        [System.IO.FileInfo[]] $Files,
        [ValidateSet("DateString", "FileName")] $GroupType
    )

    switch ($GroupType) {
        "DateString" {
            return Get-GroupAndFilesByDateString -Files $Files
        }
        "FileName" {
            return Get-GroupAndFilesByFileNamePattern -Files $Files
        }
        Default {
            return Get-GroupAndFilesByDateString -Files $Files
        }
    }
}

function Get-GroupAndFilesByDateString {
    param (
        [System.IO.FileInfo[]] $Files,
        [string] $GroupDateString = "yyyy-MM-dd"
    )

    return ($Files | Group-Object -Property { $_.LastWriteTime.toString($GroupDateString) })
}

function Get-GroupAndFilesByFileNamePattern {
    param (
        [System.IO.FileInfo[]] $Files,
        [string] $FileNamePattern = "\d{4}\-\d{2}\-\d{2}"
    )
        
        
    return ($Files | Group-Object -Property { $_.Name -match $FileNamePattern > $Null; $Matches[0] })
}

function Start-CreationOfNewStructureAndMoveFiles {
    param (
        [Microsoft.PowerShell.Commands.GroupInfo[]] $GroupsAndFiles,
        [string] $Target
    )

    $GroupsAndFiles | ForEach-Object {
        $autoIncrementIndex = 0
        $currentGroupName = $_.Name
        $currentGroupTarget = "$Target/$currentGroupName"

        if (!(Test-Path $currentGroupTarget)) { 
            New-Item -Type Directory -Path "$currentGroupTarget"
        } else {
            # FIXME: 2020-06-03 iodar dirty fix, this should be corrected
            # ideally this 'while' construct is refactored and the regex deleting
            # the current postfix can be refactored
            while (Test-Path $currentGroupTarget) {
                # transform from int to string and left pad `0`
                $autoIncrementIndex++
                $postfix = $autoIncrementIndex.ToString().PadLeft(3, '0')
                # delete autoincrement postfix if one exists
                $currentGroupTarget = $currentGroupTarget -replace "_\d{3}$", ""
                # append postfix
                $currentGroupTarget += "_$postfix"
            }

            # create folder
            New-Item -Type Directory -Path "$currentGroupTarget"
        }


        $_.Group | ForEach-Object {
            $fileName = $_.Name
            $currentFileName = $_.FullName

            if ($CopyMode) {
                Copy-Item -Path "$currentFileName" -Destination "$currentGroupTarget/$fileName"
            } else {
                Move-Item -Path "$currentFileName" -Destination "$currentGroupTarget/$fileName"
            }
        }
    }
}

$elementsToGroupAndMove = Get-AllElementsRecurse -Path $SourceFolder
$groupsAndFiles = Get-GroupsAndFiles -GroupType $GroupType -Files $elementsToGroupAndMove
Start-CreationOfNewStructureAndMoveFiles -Target $TargetFolder -GroupsAndFiles $groupsAndFiles
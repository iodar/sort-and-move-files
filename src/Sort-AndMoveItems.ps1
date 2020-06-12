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
    [ValidateSet(
        "DateString"
    )]
    $GroupType,
    [string[]]
    $GroupDefintions
)

# GLOBALS
$scriptName = $MyInvocation.MyCommand.Name

function Get-AllElementsRecurse {
    param(
        [string] $Path
    )

    return Get-ChildItem -Path $Path -Recurse -Exclude "$scriptName"
}

function Get-GroupsAndFiles {
    param (
        [System.IO.FileInfo[]] $Files,
        [string[]] $GroupDefintions = @("yyyy-MM-dd"),
        [ValidateSet(
            "DateString"
        )]
        [string] $GroupType
    )

    switch ($GroupType) {
        "DateString" { 
            return Get-GroupsAndFilesByDateString -Files $Files -GroupDefintions $GroupDefintions
        }
    }
}

function Get-GroupsAndFilesByDateString {
    [System.IO.FileInfo[]] $Files,
    [string[]] $GroupDefintions

    $groupCriteriasArray = [System.Collections.ArrayList]@()

    foreach ($groupDefintion in $GroupDefintions) {
        $groupCriteriasArray.Add( { $_.LastWriteTime.toString($groupDefintion) })
    }

    return ($Files | Group-Object -Property $groupCriteriasArray)
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
            Move-Item -Path "$currentFileName" -Destination "$currentGroupTarget/$fileName"
        }
    }
}

$elementsToGroupAndMove = Get-AllElementsRecurse -Path $SourceFolder
Write-Output $elementsToGroupAndMove
$groupsAndFiles = Get-GroupsAndFiles -Files $elementsToGroupAndMove -GroupType $GroupType -GroupDefintions $GroupDefintions
Write-Output $groupsAndFiles
# Start-CreationOfNewStructureAndMoveFiles -Target $TargetFolder -GroupsAndFiles $groupsAndFiles
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
    # custom postfix to append to folder names
    [Parameter()]
    [string]
    $CustomPostfix
)

function Get-AllElementsRecurse {
    param(
        [string] $Path
    )

    return Get-ChildItem -Path $Path -Recurse
}

function Get-GroupsAndFiles {
    param (
        [System.IO.FileInfo[]] $Files,
        [string] $GroupDateString = "yyyy-MM-dd"
    )

    return ($Files | Group-Object -Property { $_.LastWriteTime.toString($GroupDateString) })
}

function Start-CreationOfNewStructureAndMoveFiles {
    param (
        [Microsoft.PowerShell.Commands.GroupInfo[]] $GroupsAndFiles,
        [string] $Target
    )

    $GroupsAndFiles | ForEach-Object {
        $currentGroupName = $_.Name
        $currentGroupTarget = "$Target/$currentGroupName"
        New-Item -Type Directory -Path "$currentGroupTarget"
        $_.Group | ForEach-Object {
            $fileName = $_.Name
            $currentFileName = $_.FullName
            Move-Item -Path "$currentFileName" -Destination "$currentGroupTarget/$fileName"
        }
    }
}

$elementsToGroupAndMove = Get-AllElementsRecurse -Path $SourceFolder
$groupsAndFiles = Get-GroupsAndFiles -GroupDateString "yyyy-MM-dd" -Files $elementsToGroupAndMove
Start-CreationOfNewStructureAndMoveFiles -Target $TargetFolder -GroupsAndFiles $groupsAndFiles
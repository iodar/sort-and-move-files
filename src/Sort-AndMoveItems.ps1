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

return @{
    SourceFolder  = $SourceFolder
    TargetFolder  = $TargetFolder
    CustomPostfix = $CustomPostfix
}
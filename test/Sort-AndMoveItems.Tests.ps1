$scriptFile = "./../src/Sort-AndMoveItems.ps1"

function Assert-HashtableEquality() {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = 1)]
        [hashtable]
        $Actual,
        [Parameter()]
        [hashtable]
        $Expected
    )
    $Actual.Keys | Should -HaveCount $Expected.Keys.Count
    $Actual.Keys | ForEach-Object { $Actual[$_] | Should -Be $Expected[$_] }
}

Describe "Sort-AndMoveItems.ps1" {
    Context "import and return" {
        It "should return values of parametes" {
            & $scriptFile -SourceFolder "./test" -TargetFolder "./test2" -CustomPostfix "NIKON" |
            Assert-HashtableEquality -Expected @{
                SourceFolder  = "./test"
                TargetFolder  = "./test2"
                CustomPostfix = "NIKON"
            }
        }
    }
}

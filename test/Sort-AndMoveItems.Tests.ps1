$scriptFile = "./../src/Sort-AndMoveItems.ps1"

# CUSTOM ASSERTS

function Assert-EqualHashTable() {
    [CmdletBinding()]
    param (
        [Parameter()]
        [hashtable]
        $Actual,
        [Parameter()]
        [hashtable]
        $Expected
    )
    $Actual.Keys | Should -HaveCount $Expected.Keys.Count
    $Actual.Keys | ForEach-Object { $Actual[$_] | Should -Be $Expected[$_] }
}

# TEST HELPER FUNCTIONS

function New-Testdata {
    param (
        [string] $TargetFolder
    )
    
    New-Item -ItemType Directory -Path $TargetFolder -Name "001.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/001.JPEG" -Name LastWriteTime -Value "2019-09-10T16:45:23.763"

    New-Item -ItemType Directory -Path $TargetFolder -Name "002.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/002.JPEG" -Name LastWriteTime -Value "2020-01-17T16:45:23.763"

    New-Item -ItemType Directory -Path $TargetFolder -Name "003.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/003.JPEG" -Name LastWriteTime -Value "2020-02-21T16:45:23.763"

    New-Item -ItemType Directory -Path $TargetFolder -Name "004.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/004.JPEG" -Name LastWriteTime -Value "2020-02-12T16:45:23.763"

    New-Item -ItemType Directory -Path $TargetFolder -Name "005.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/005.JPEG" -Name LastWriteTime -Value "2020-04-13T16:45:23.763"

    return @("$TargetFolder/001.JEPG", "$TargetFolder/002.JEPG", "$TargetFolder/003.JEPG", "$TargetFolder/004.JEPG", "$TargetFolder/005.JEPG")
}

Describe "Sort-AndMoveItems.ps1" {
    Context "import and return" {
        It "should return values of parametes" {
            $scriptReturnValue = & $scriptFile -SourceFolder "./test" -TargetFolder "./test2" -CustomPostfix "NIKON"
            Assert-EqualHashTable -Actual $scriptReturnValue -Expected @{
                SourceFolder  = "./test"
                TargetFolder  = "./test2"
                CustomPostfix = "NIKON"
            }
        }
    }
}

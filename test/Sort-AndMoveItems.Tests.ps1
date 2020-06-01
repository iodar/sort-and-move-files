$scriptFile = "$PSScriptRoot/../src/Sort-AndMoveItems.ps1"
$testFolder = "$PSScriptRoot/temp"

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
    
    New-Item -ItemType File -Path $TargetFolder -Name "001.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/001.JPEG" -Name LastWriteTime -Value "2019-09-10T16:45:23.763"

    New-Item -ItemType File -Path $TargetFolder -Name "002.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/002.JPEG" -Name LastWriteTime -Value "2020-01-17T16:45:23.763"

    New-Item -ItemType File -Path $TargetFolder -Name "003.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/003.JPEG" -Name LastWriteTime -Value "2020-02-12T16:45:23.763"

    New-Item -ItemType File -Path $TargetFolder -Name "004.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/004.JPEG" -Name LastWriteTime -Value "2020-02-12T16:45:23.763"

    New-Item -ItemType File -Path $TargetFolder -Name "005.JPEG" &&
    Set-ItemProperty -Path "$TargetFolder/005.JPEG" -Name LastWriteTime -Value "2020-04-13T16:45:23.763"

    return @("$TargetFolder/001.JEPG", "$TargetFolder/002.JEPG", "$TargetFolder/003.JEPG", "$TargetFolder/004.JEPG", "$TargetFolder/005.JEPG")
}

# TESTS

Describe "Sort-AndMoveItems.ps1" {
    Context "Simple Import" {
        BeforeEach -Scriptblock {
            New-Item -Type Directory -Path "$testFolder/source"
            New-Item -Type Directory -Path "$testFolder/target"
        }

        AfterEach -Scriptblock {
            Test-Path "$testFolder" && Remove-Item -Recurse -Path "$testFolder"
        }

        It "should import all files into structure" {
            # prepare
            $testfiles = New-Testdata -TargetFolder "$testFolder/source"

            # exec
            $scriptReturnValue = & $scriptFile -SourceFolder "$testFolder/source" -TargetFolder "$testFolder/target"

            # assert
            $actualStructure = Resolve-Path (Get-ChildItem -Recurse -Path "$testFolder/target/*").FullName -Relative
            $relTestFolder = Resolve-Path -Relative "$testFolder"
            $actualStructure | Should -BeIn @(
                "$relTestFolder/target/2019-09-10/001.JPEG",
                "$relTestFolder/target/2020-01-17/002.JPEG",
                "$relTestFolder/target/2020-02-12/003.JPEG",
                "$relTestFolder/target/2020-02-12/004.JPEG",
                "$relTestFolder/target/2020-04-13/005.JPEG"
            )

        }
    }
}

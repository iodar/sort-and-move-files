# TESTS

Describe "Sort-AndMoveItems.ps1" {

    BeforeAll {
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

            return @(
                "$TargetFolder/001.JEPG", 
                "$TargetFolder/002.JEPG", 
                "$TargetFolder/003.JEPG", 
                "$TargetFolder/004.JEPG", 
                "$TargetFolder/005.JEPG"
            )
        }

        function Invoke-CreationOfTestfolders {
            New-Item -Type Directory -Path (Join-Path $testFolder "source")
            New-Item -Type Directory -Path (Join-Path $testFolder "target")
        }

        function Invoke-CleanUp {
            Test-Path "$testFolder" && Remove-Item -Recurse -Path "$testFolder"
        }

        # CUSTOM VARS
        
        $scriptFile = Join-Path $PSScriptRoot ".." "src" "Sort-AndMoveItems.ps1" -Resolve
        $testFolder = Join-Path $PSScriptRoot "temp"
    }

    BeforeEach -Scriptblock {
        Invoke-CreationOfTestfolders
    }

    AfterEach -Scriptblock {
        Invoke-CleanUp
    }
    
    Context "Simple Import" {
        It "should import all files into structure" {
            # prepare
            $relTestFolder = Resolve-Path -Relative "$testFolder"
            $expectedStructure = @(
                (Join-Path $relTestFolder "target" "2019-09-10" "001.JPEG"),
                (Join-Path $relTestFolder "target" "2020-01-17" "002.JPEG"),
                (Join-Path $relTestFolder "target" "2020-02-12" "003.JPEG"),
                (Join-Path $relTestFolder "target" "2020-02-12" "004.JPEG"),
                (Join-Path $relTestFolder "target" "2020-04-13" "005.JPEG")
            )
            New-Testdata -TargetFolder (Join-Path $testFolder "source" -Resolve)

            # exec
            & $scriptFile -SourceFolder (Join-Path $testFolder "source" -Resolve) -TargetFolder (Join-Path $testFolder "target" -Resolve)

            # assert
            $actualStructure = @(Resolve-Path (Get-ChildItem -Recurse -Path (Join-Path $testFolder "target" "*" -Resolve)).FullName -Relative)
            $actualStructure | Should -Be $expectedStructure

            Start-Sleep -Seconds 10
        }

    }

    Context "Complex Import" {

    }
}

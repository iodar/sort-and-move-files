$tags = @{
    acceptance = "Acceptance"
}

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

        function New-TestdataSet {
            param(
                [hashtable] $TestdataMap,
                [string] $TargetFolder
            )

            $testDataMapAsArray = [System.Collections.ArrayList]@()
            
            $TestdataMap.Keys | ForEach-Object {
                New-Item -ItemType File -Path $TargetFolder -Name $_ &&
                Set-ItemProperty -Path "$TargetFolder/$_" -Name LastWriteTime -Value $TestdataMap[$_]
                $testDataMapAsArray.Add("$TargetFolder/$_")
            }

            return $testDataMapAsArray
        }

        function New-Testdata {
            param (
                [string] $TargetFolder
            )

            $testdataArray = New-TestdataSet -TargetFolder $TargetFolder -TestdataMap @{
                "001.JPEG" = "2019-09-10T16:45:23.763"
                "002.JPEG" = "2020-01-17T16:45:23.763"
                "003.JPEG" = "2020-02-12T16:45:23.763"
                "004.JPEG" = "2020-02-12T16:45:23.763"
                "005.JPEG" = "2020-04-13T16:45:23.763"
            }
    
            return $testdataArray
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
    
    Context "Simple Import" -Tag $tags.acceptance {
        It "should import all files into structure" {
            # prepare
            $relTestFolder = Resolve-Path -Relative "$testFolder"
            $expectedStructure = @(
                (Join-Path $relTestFolder "target" "2019-09-10" "001.JPEG"),
                (Join-Path $relTestFolder "target" "2020-01-17" "002.JPEG"),
                (Join-Path $relTestFolder "target" "2020-02-12" "003.JPEG"),
                (Join-Path $relTestFolder "target" "2020-02-12" "004.JPEG"),
                (Join-Path $relTestFolder "target" "2020-04-13" "005.JPEG")
            ) | Sort-Object
            New-Testdata -TargetFolder (Join-Path $testFolder "source" -Resolve)

            # exec
            & $scriptFile -SourceFolder (Join-Path $testFolder "source" -Resolve) -TargetFolder (Join-Path $testFolder "target" -Resolve)

            # assert
            $actualStructure = @(Resolve-Path (Get-ChildItem -Recurse -Path (Join-Path $testFolder "target" "*" -Resolve)).FullName -Relative)
            $actualStructure | Should -Be $expectedStructure
        }

    }

    Context "Complex Import" {
        Context "3 consecutive imports" {
            It "should create new folder with automatic increment as postfix" -Tag $tags.acceptance {
                # prepare
                New-Testdata -TargetFolder (Join-Path $testFolder "source" -Resolve)
                
                $relTestFolder = Resolve-Path -Relative "$testFolder"
                $expectedStructure = @(
                    (Join-Path $relTestFolder "target" "2019-09-10" "001.JPEG"),
                    (Join-Path $relTestFolder "target" "2020-01-17" "002.JPEG"),
                    (Join-Path $relTestFolder "target" "2020-02-12" "003.JPEG"),
                    (Join-Path $relTestFolder "target" "2020-02-12" "004.JPEG"),
                    (Join-Path $relTestFolder "target" "2020-04-13" "005.JPEG")
                    (Join-Path $relTestFolder "target" "2019-09-10_001" "006.JPEG"),
                    (Join-Path $relTestFolder "target" "2020-01-17_001" "007.JPEG"),
                    (Join-Path $relTestFolder "target" "2020-01-17_001" "008.JPEG")
                    (Join-Path $relTestFolder "target" "2019-09-10_002" "009.JPEG"),
                    (Join-Path $relTestFolder "target" "2020-01-17_002" "010.JPEG")
                ) | Sort-Object

                # exec #1/3
                & $scriptFile -SourceFolder (Join-Path $testFolder "source" -Resolve) -TargetFolder (Join-Path $testFolder "target" -Resolve)
                
                # create new data
                New-TestdataSet -Target (Join-Path $testFolder "source" -Resolve) -TestdataMap @{
                    "006.JPEG" = "2019-09-10T16:45:23.763"
                    "007.JPEG" = "2020-01-17T16:45:23.763"
                    "008.JPEG" = "2020-01-17T16:45:23.763"
                }
                
                # exec #2/3
                & $scriptFile -SourceFolder (Join-Path $testFolder "source" -Resolve) -TargetFolder (Join-Path $testFolder "target" -Resolve)
                
                # create new data
                New-TestdataSet -Target (Join-Path $testFolder "source" -Resolve) -TestdataMap @{
                    "009.JPEG" = "2019-09-10T16:45:23.763"
                    "010.JPEG" = "2020-01-17T16:45:23.763"
                }

                # exec #3/3
                & $scriptFile -SourceFolder (Join-Path $testFolder "source" -Resolve) -TargetFolder (Join-Path $testFolder "target" -Resolve)

                # assert
                $actualStructure = @(Resolve-Path (Get-ChildItem -Recurse -Path (Join-Path $testFolder "target" "*" -Resolve)).FullName -Relative) | Sort-Object
                $actualStructure | Should -Be $expectedStructure
            }
        }
    }
}

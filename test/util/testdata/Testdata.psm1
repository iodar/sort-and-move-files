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

Export-ModuleMember -Function New-TestdataSet, New-Testdata
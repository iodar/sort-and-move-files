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

Export-ModuleMember -Function Assert-EqualHashTable
param (
  [switch] $Coverage
)

if ($Coverage) {
  Invoke-Pester -CodeCoverage $PSScriptRoot/src/Sort-AndMoveItems.ps1 . 
} else {
  Invoke-Pester .
}


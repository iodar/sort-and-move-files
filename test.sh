#!/bin/bash

[ "$1" == "--coverage" ] && 
  /usr/bin/pwsh -c 'Invoke-Pester -CodeCoverage ./src/Sort-AndMoveItems.ps1' || 
  /usr/bin/pwsh -c 'Invoke-Pester .'

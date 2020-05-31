<# Create delegates that will be used when a file is altered and when when it is renamed #>
$updated = { Write-Host "File: " $EventArgs.FullPath " " $EventArgs.ChangeType ; $global:UpdateEvent = $EventArgs }

$Renamed = { Write-Host "File: " $EventArgs.OldFullPath " renamed to "$EventArgs.FullPath ; $global:RenameEvent = $EventArgs }



<# Create a fileWatcher that will monitor the directory and add its attributes#>
$fileWatcher = new-object System.IO.FileSystemWatcher
$fileWatcher.Path = "<files>"
$fileWatcher.Filter = "*.Tests.ps1";
$fileWatcher.IncludeSubdirectories = $true
$fileWatcher.NotifyFilter = [System.IO.NotifyFilters]::LastAccess , `
    [System.IO.NotifyFilters]::LastWrite, `
    [System.IO.NotifyFilters]::FileName , `
    [System.IO.NotifyFilters]::DirectoryName

<# If a delegate has already been added to the FileWatchers for that event remove it and add the new one. #>
if ($ChangedEvent) { $ChangedEvent.Dispose() }
$ChangedEvent = Register-ObjectEvent $fileWatcher "Changed" -Action { $updated; Invoke-Pester -Script "<tests>" }

if ($CreatedEvent) { $CreatedEvent.Dispose() }
$CreatedEvent = Register-ObjectEvent $fileWatcher "Created" -Action $updated

if ($DeletedEvent) { $DeletedEvent.Dispose() }
$DeletedEvent = Register-ObjectEvent $fileWatcher "Deleted" -Action $updated

if ($RenamedEvent) { $RenamedEvent.Dispose() }
$RenamedEvent = Register-ObjectEvent $fileWatcher "Renamed" -Action $Renamed

$fileWatcher.EnableRaisingEvents = $true
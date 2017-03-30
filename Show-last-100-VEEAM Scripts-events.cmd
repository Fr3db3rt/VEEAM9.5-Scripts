@echo off
set PScmd=%0
set PSscript=PowerShell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command -
echo %0 %PSscript%
more +8 %0 | %PSscript%
exit /b

### PowerShell script starts here ###
Write-Host -fore green "Starte PowerShell..." 
Write-Host -fore green "VEEAM Update Downloader with BITS for VeeamBackup&Replication_9.5.0.711.iso..."
$msg = "Info: VEEAM Version 9.x script execution - "
$msg += $env:PScmd
$msg += " - Check scripts in c:\scripts... for more information."
New-EventLog -LogName "Application" -Source "VEEAM Scripts" -ErrorAction:SilentlyContinue
Write-EventLog -LogName "Application" -Source "VEEAM Scripts" -EventID 65535 -EntryType Information -Message $msg

# ..................................
# Show last 100 VEEAM Scripts events
# ..................................

PowerShell.exe -WindowStyle Hidden -Command "& {Get-winevent -FilterHashtable @{ LogName = 'Application' ; ProviderName = 'VEEAM Scripts'} -MaxEvents 100 | Out-GridView -wait}"

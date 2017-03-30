@echo off
set PScmd=%0
set PSscript=PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
echo %0 %PSscript%
more +8 %0 | %PSscript%
exit /b

### PowerShell script starts here ###
Write-Host -fore green "Starte PowerShell..." 
Write-Warning "Viren Scanner Dienste werden jetzt beendet..."
$msg = "Info: VEEAM Version 9.x script execution - "
$msg += $env:PScmd
$msg += " - Check scripts in c:\scripts... for more information."
New-EventLog -LogName "Application" -Source "VEEAM Scripts" -ErrorAction:SilentlyContinue
Write-EventLog -LogName "Application" -Source "VEEAM Scripts" -EventID 65535 -EntryType Information -Message $msg
Get-Service -DisplayName *veeam*,*veeamsql*
Get-Service -DisplayName *veeam* | Stop-Service -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue -Verbose -Exclude *veeamsql*
Get-Service -DisplayName *veeamsql* | Stop-Service -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue -Verbose
Get-Service -DisplayName *veeam*,*veeamsql*
Get-Process *veeam* | Stop-Process -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue -Verbose
Write-Host -fore green "Fertig`nScript beendet"

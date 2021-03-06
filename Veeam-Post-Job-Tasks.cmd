@echo off
set PScmd=%0
set PSscript=PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
echo %0 %PSscript%
more +8 %0 | %PSscript%
exit /b

### PowerShell script starts here ###
Write-Host -fore green "Starte PowerShell..."
$msg = "Info: VEEAM Version 9.x script execution - "
$msg += $env:PScmd
$msg += " - Check scripts in c:\scripts... for more information."
Write-Warning 'Viren Scanner Dienste werden jetzt gestartet...'
New-EventLog -LogName "Application" -Source "VEEAM Scripts" -ErrorAction:SilentlyContinue
Write-EventLog -LogName "Application" -Source "VEEAM Scripts" -EventID 65535 -EntryType Information -Message $msg
Get-Service -DisplayName trend*,officescan*
Get-Service -DisplayName trend*,officescan* | Start-Service -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue -Verbose
Get-Service -DisplayName trend*,officescan*
Write-Host  -fore green "Fertig`nScript beendet"

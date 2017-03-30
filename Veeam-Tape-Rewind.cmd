@echo off
set PScmd=%0
set PSscript=PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
echo %0 %PSscript%
more +8 %0 | %PSscript%
exit /b

### PowerShell script starts here ###
Write-Host -fore green "Starte PowerShell..."
$msg += "*** Achtung: ***`n"
$msg = "Info: VEEAM Version 9.x script execution - "
$msg += $env:PScmd
$msg += " - Check scripts in c:\scripts... for more information."
New-EventLog -LogName "Application" -Source "VEEAM Scripts" -ErrorAction:SilentlyContinue
Write-EventLog -LogName "Application" -Source "VEEAM Scripts" -EventID 65535 -EntryType Information -Message $msg

Add-PSSnapin VeeamPSSnapin

write-host "Tape Library einlesen ..."
$library = Get-VBRTapeLibrary
write-host "VBRTapeLibrary = $library"

write-host "Drive identifizieren ..."
$drive = Get-VBRTapeDrive
write-host "VBRTapeDrive = $drive"

write-host "Inventarisierung starten und auf Abschluss warten ..."
Start-VBRTapeInventory -Library $library -wait

write-host "aktuelles Tape identifizieren ..."
$tape = Get-VBRTapeMedium -Drive $drive
write-host "VBRTapeMedium = $tape"

write-host "Fertig`nScript beendet"

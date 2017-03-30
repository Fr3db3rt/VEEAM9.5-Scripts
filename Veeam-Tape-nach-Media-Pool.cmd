@echo off
set PScmd=%0
set PSscript=PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
echo %0 %PSscript%
more +8 %0 | %PSscript%
exit /b

### PowerShell script starts here ###
# Clear-Host
Write-Host -fore green "Starte PowerShell..."
$msg = "Info: VEEAM Version 9.x script execution - "
$msg += $env:PScmd
$msg += " - Check scripts in c:\scripts... for more information."
New-EventLog -LogName "Application" -Source "VEEAM Scripts" -ErrorAction:SilentlyContinue
Write-EventLog -LogName "Application" -Source "VEEAM Scripts" -EventID 65535 -EntryType Information -Message $msg
#--------------------------------------------------------------------
# Add Veeam snap-in if required

If ((Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue) -eq $null) {
   Add-PSSnapin VeeamPSSnapin
   }
#--------------------------------------------------------------------
# Check presence if VEEAM PowerShell plugin is installed or not

If ((Get-PSSnapin -Name VeeamPSSnapin -ErrorAction SilentlyContinue) -eq $null) {
   [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
   $nl = [System.Environment]::NewLine + [System.Environment]::NewLine
   $msg = "*** Achtung: ***`n"
   $msg += "Das VEEAM PowerShell Snapin ist nicht vorhanden!`n"
   $msg += "Zuerst muß die VEEAM PowerShell installiert werden.`n"
   $msg += "Das Script wird nun beendet.`n"
   [System.Windows.Forms.MessageBox]::Show($msg,"?error. " + $myInvocation.MyCommand.Name,"OK","Error")
   exit
   }
#--------------------------------------------------------------------
# Check Veeam Version (If VEEAM 9)

If ((Get-PSSnapin VeeamPSSnapin).Version.Major -ne 9) {
   New-EventLog –LogName Application –Source "VEEAM Scripts" -ErrorAction:SilentlyContinue
   Write-EventLog -LogName "Application" -Source "VEEAM Scripts" -EventID 3001 -EntryType Warning -Message "ERROR: VEEAM Version 9.x script execution error! Check scripts in c:\scripts..."
   exit
   }

#--------------------------------------------------------------------
# Main Procedures
Write-Host "********************************************************************************"
write-host "Starting Veeam Script" $myInvocation.MyCommand.Name
Write-Host "********************************************************************************`n"
#--------------------------------------------------------------------

write-host "`nTape Sever identifizieren ..."
Get-VBRLocalhost | Get-VBRTapeServer
    
write-host "`nTape Library einlesen ..."
Get-VBRTapeServer | Get-VBRTapeLibrary

write-host "`n...inventarisieren und auf Abschluss warten ..."
Get-VBRTapeLibrary | Start-VBRTapeInventory -wait

write-host "`nAktuelles Tape Drive identifizieren ..."
$drive = Get-VBRTapeDrive

write-host "`n...und Katalog des aktuellen Bandes einlesen und auf Abschluss warten."
Get-VBRTapeMedium -Drive $drive | Start-VBRTapeCatalog -Wait

write-host "`nAktuelles Medium in den Pool 'FREE' schieben ..."
Get-VBRTapeMedium -Drive $drive | Move-VBRTapeMedium -MediaPool "Free" -Confirm:$false

write-host "`n... und loeschen und auf Abschluss warten ..."
Get-VBRTapeMedium -Drive $drive | Erase-VBRTapeMedium -wait -Confirm:$false

exit

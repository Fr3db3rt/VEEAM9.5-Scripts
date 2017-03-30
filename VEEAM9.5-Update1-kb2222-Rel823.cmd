@echo off
set PScmd=%0
set PSscript=PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
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

# .................................................
# VEEAM Update Downloader with BITS
# for VeeamBackup&Replication_9.5.0.823_Update1.zip
# .................................................

# Definitions ...
# Origin source https://dataspace.xxx.de/#/public/shares-downloads/nOYRCOb0DBfEKVdQNqzJleyTG3uHVd58
$source = "https://dataspace.xxx.de/api/v4/public/shares/downloads/nOYRCOb0DBfEKVdQNqzJleyTG3uHVd58/829i8iyeRYqijbWv401yKzmXKEqZywG3d9REFVozDHgr1KOgVeerwrzy4KvBgo_HigK5VBRdq1escT1kWS4e-FLMzuz9G43zOcU4JLccG4w0uk8XFxe9vyjW3ekJDANO8GFUrXa9bVRl0M05MRnW4vf83u_wMx-NkTsTJpNL3e6BjIynoOBm3cF4b781ae2439aef39b"
$destinationfile = "VeeamBackup&Replication_9.5.0.823_Update1.zip"
$destinationpath = "c:\scripts\updates\"
$destination = $destinationpath + $destinationfile
write-host $source
write-host $destinationfile
write-host $destinationpath
write-host $destination
write-host ""
# ...........

# Download ...
write-host -fore green "Import-Module BitsTransfer"
Import-Module BitsTransfer

write-host -fore green "Start-BitsTransfer -Source $source -Destination $destination -Description "Downloading..." -DisplayName "by BitsTransfer" -ProxyUsage SystemDefault -Priority Foreground -RetryInterval 120"
Start-BitsTransfer -Source $source -Destination $destination -Description "Downloading..." -DisplayName "by BitsTransfer" -ProxyUsage SystemDefault -Priority Foreground -RetryInterval 120
# -Asynchronous
#
Get-BitsTransfer | Resume-BitsTransfer
Get-BitsTransfer | Complete-BitsTransfer
Get-BitsTransfer
write-host -fore green "Download finished"
# ............

# Zip and/or Unzip ...
Add-Type -A System.IO.Compression.FileSystem

# ZIP
# write-host -fore green "Compress..."
# [IO.Compression.ZipFile]::CreateFromDirectory( $destinationpath, $destinationpath + $destinationfile)
# write-host -fore green "[IO.Compression.ZipFile]::CreateFromDirectory( $destinationpath, $destinationpath + $destinationfile)"

# Unzip
write-host -fore green "Extract..."
write-host -fore green "[IO.Compression.ZipFile]::ExtractToDirectory( $destinationpath + $destinationfile, $destinationpath)"
[IO.Compression.ZipFile]::ExtractToDirectory( $destinationpath + $destinationfile, $destinationpath)

write-host -fore green "File processed"
# ............
Write-Host -fore green "Fertig`nScript beendet"

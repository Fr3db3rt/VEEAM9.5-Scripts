@echo off
set PScmd=%0
set PSscript=PowerShell -NoProfile -ExecutionPolicy Bypass -Command -
echo %0 %PSscript%
more +9 %0 | %PSscript%
cmd /c pause
exit /b

### PowerShell script starts here ###
Write-Host -fore green "Starte PowerShell...`n`n`n`n" 
Write-Host -fore green "VEEAM Update Downloader with BITS for VeeamBackup&Replication_9.5.0.711.iso..."
$msg = "Info: VEEAM Version 9.x script execution - "
$msg += $env:PScmd
$msg += " - Check scripts in c:\scripts... for more information."
New-EventLog -LogName "Application" -Source "VEEAM Scripts" -ErrorAction:SilentlyContinue
Write-EventLog -LogName "Application" -Source "VEEAM Scripts" -EventID 65535 -EntryType Information -Message $msg

# .........................................
# VEEAM Update Downloader with BITS
# for VeeamBackup&Replication_9.5.0.711.iso
# .........................................

# Definitions ...
# Origin source: https://dataspace.livingdata.de/#/public/shares-downloads/51B1v2phMU1Ghl96cXyXuq90TJGyWitF
$source = "https://dataspace.livingdata.de/api/v4/public/shares/downloads/51B1v2phMU1Ghl96cXyXuq90TJGyWitF/LzD68Bj3jbUzSS5Xcpm79rqsQFQtR-lfZ0B92NCxNoZJY6LTiz-oFQ83_mPBTXOI0oNQ_SUWquMbmWI1iILfBnWsnxUQIIZmZyk6_4n485lethOdYeDRikG-ITqk0Cjq4EZBK1vUFmNB6nsow0QMTFj15t1uEQladfb9MnI0k4Pptoob8xH0mjTJ0553efde6fe2c2e1"
$destinationfile = "VeeamBackup&Replication_9.5.0.711.iso"
$destinationpath = "c:\scripts\updates\"
$destination = $destinationpath + $destinationfile
write-host -fore green "--- SOURCE: ---------------------------------------------------------------------------"
write-host $source
write-host -fore green "--- DESTINATIONFILE: ------------------------------------------------------------------"
write-host $destinationfile
write-host -fore green "--- DESTINATIONPATH: ------------------------------------------------------------------"
write-host $destinationpath
write-host -fore green "--- DESTINATION: ----------------------------------------------------------------------"
write-host $destination
write-host -fore green "---------------------------------------------------------------------------------------`n"
write-host ""

write-host -fore green "wget $source -outfile $destination"
wget $source -outfile $destination

# Zip and/or Unzip ...
Add-Type -A System.IO.Compression.FileSystem

# ZIP
# write-host -fore green "Compress..."
# [IO.Compression.ZipFile]::CreateFromDirectory( $destinationpath, $destinationpath + $destinationfile)
# write-host -fore green "[IO.Compression.ZipFile]::CreateFromDirectory( $destinationpath, $destinationpath + $destinationfile)"

# Unzip
# write-host -fore green "Extract..."
# write-host "[IO.Compression.ZipFile]::ExtractToDirectory( $destinationpath + $destinationfile, $destinationpath)"
[IO.Compression.ZipFile]::ExtractToDirectory( $destinationpath + $destinationfile, $destinationpath)

write-host -fore green "File processed"
# ............
Write-Host -fore green "Fertig`nScript beendet"

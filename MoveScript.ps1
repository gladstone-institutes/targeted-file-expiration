#######################
# PATH & Date options #
#######################

#
# Source path, where to look for files to hide
#
$Source = "C:\Users"

#
# Destination path, where we'll "hide" the files from users.
#
# To minimize performance impact on active imaging acquisition computers, it's suggest to keep the source and destination on the same volume. e.g.: c: or d: for both source and destination.
#
$Destination = "C:\TO-BE-DELETED"

#
# Age Limit Filter. Set files older than X days in the negative. Defaults to 1 month: -30
#
$limit = (Get-Date).AddDays(-30)
 
####################
# Filetype Filters #
####################
 
#
# This script will only look for specific filetypes, and ignore all others. This is to remove the large image files, but keep other critical files such as configuration or calibration files.
#
# In Where-Object, you'll see >>$_.Extension -eq ".tif"<<. This is how you look for each filetype. Add that as many $_.Extension statements as needed with -or between them to set the filetypes to search for.
#
# Be sure to leave the last part of "Where-Object, where it lists the timeframe cutoff. Removing or modifying that will make this script potentially catch ALL files, regardless of age.
#
# This script is setup by default with some of the most common imaging formats
#

Get-ChildItem -Path $Source -Recurse | Where-Object { $_.Extension -eq ".tif" -or $_.Extension -eq ".tiff" -or $_.Extension -eq ".czi" -or $_.Extension -eq ".jpeg" -or $_.Extension -eq ".jpg" -or $_.Extension -eq ".ims" -or $_.Extension -eq ".nd2" -or $_.Extension -eq ".avi" -and $_.LastWriteTime -lt $limit } | ForEach-Object{
    $DestPath=$Destination + $_.DirectoryName.Replace($Source,"")
    New-Item $DestPath -type directory -ErrorAction SilentlyContinue
    Move-Item $_.FullName -destination $DestPath -Force
}

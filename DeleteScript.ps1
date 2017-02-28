#######################
# PATH & Date options #
#######################
 
#
# Source path, where to look for files to delete
#
$path = "C:\TO-BE-DELETED"
 
#
# Age Limit Filter. Set files older than X days in the negative. Defaults to 2 months: -60
#
$limit = (Get-Date).AddDays(-60)
 
 
# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit } | Remove-Item -Force
 
# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

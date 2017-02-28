# Targeted File Expiration for Image Acquisition computers #
Image acquisition with scientific instruments has improved greatly over the years with computer-connected acquisition machines. What hasn't improved is the day-to-day cleanup of files to ensure there's enough local room on these machines to allow for more users to capture images.

This scripts sets out to make a Windows-native auto-expiration system which specifically targets image files, but leaves other user profile settings alone such as configuration settings, notes, or other non-imaging files.

This consists of two *PowerShell* files, **MoveScript.ps1** and **DeleteScript.ps1** which makes it easier to encourage scientists to cleanup their imaging runs while minimizing the likelihood of losing the only copy of captured samples.

## Phase 1 - Hide the images ##

**MoveScript.ps1** has a few customizable options which will specify what kinds of files to target, as well as a time cutoff and where to hide the folders:

`$Source = "C:\Users` This is where to search for images. Typically these will either be stored in user's home directories under C:\Users or else on a D: Data drive.

`$Destination = "C:\TO-BE-DELETED"` This is the hidden folder where files will be stored. To minimize the potential impact if there are imaging runs moving, keep this folder on the same storage device as the source images.

`$limit = (Get-Date).AddDays(-30)` This is the time cutoff in negative to go backwards in time. This sets how many calendar days ago to look for files written before X days ago.

The final part to edit is within the `Where-Object` statement of the script itself.  The published script contains most of the common microscopy imaging formats, but specific use cases may require refining or expanding the file type filters. 

The script searches for the following file types by default:

 - .tif
 - .tiff
 - .czi
 - .jpeg
 - .ims
 - .nd2
 - .avi

New file types can be added by adding or removing as many of `-or $_.Extension -eq ".ext"` as necessary.

## Phase 2 - Delete Files and cleanup empty folders ##

**DeleteScript.ps1 ** doesn't have nearly the customization, because the filters already took place through the first script. This just goes through the hidden folder and deletes files older than X days (which should be a larger value than the move script). It also has a routine to go through and delete any empty folders, to keep from cluttering the inode tables with excess folders.

***NOTE:*** It is *highly* recommended to manually execute the powershell script with the date modified to a greater value for the first run. This will give users time to realize they've lost files without them being deleted. If space permits, 6 months (`-180` days) is recommended.

`$path = "C:\TO-BE-DELETED"` The path where the images are hidden

`$limit = (Get-Date).AddDays(-60)` This is the time cutoff in negative to go backwards in time. This sets how many calendar days ago to look for files written before X days ago.

## Running the scripts  ##

Because of the native *PowerShell* restrictions on Windows, simply saving the files and double-clicking on them won't work. The way around it is to run powershell with the argument `-ExecutionPolicy Bypass` and then the path to the script.

The set and forget method would be setting up the scripts to run with Window's built-in **Task Scheduler**:

**Hiding Images Phase**

 1. Setup a second hidden folder to contain the scripts. i.e. `C:\scripts`
 2. Save **MoveScript.ps1** and **DeleteScript.ps1** into `C:\scripts`
 3. Open up **Computer Management** and navigate to *System Tools* > *Task Scheduler* > *Task Scheduler Library*
 4. Select **Create Task** in the *Actions* pane on the right side
 5. Set *Name* to a descriptive name such as **Hide Old Files**. This helps identify the task in the list of scheduled tasks.
 6. Under *Security options*, select **Change User or Group...** Change the user to **SYSTEM** from your user account to prevent access issues.
 7. Under the *Triggers* tab, select **New...** to add a trigger to set the day(s) and time(s) that the script will run. Be sure to set a time when the computer will likely be idle, but on as a safeguard against interrupting ongoing capture.
 8. Under the *Actions* tab, select **New...** to add a trigger to start PowerShell and launch the script:
**Action:** Start a program
**Program/script:** `%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe`
**Add Arguments:** `-ExecutionPolicy Bypass C:\scripts\MoveScript.ps1` (or whatever the move script is named)

**Deletion Phase**

1. Save **MoveScript.ps1** and **DeleteScript.ps1** into `C:\scripts`
2. Open up **Computer Management** and navigate to *System Tools* > *Task Scheduler* > *Task Scheduler Library*
3. Select **Create Task** in the *Actions* pane on the right side
4. Set *Name* to a descriptive name such as **Hide Old Files**. This helps identify the task in the list of scheduled tasks.
5. Under *Security options*, select **Change User or Group...** Change the user to **SYSTEM** from your user account to prevent access issues.
6. Under the *Triggers* tab, select **New...** to add a trigger to set the day(s) and time(s) that the script will run. Be sure to set a time when the computer will likely be idle, but on as a safeguard against interrupting ongoing capture.
7. Under the *Actions* tab, select **New...** to add a trigger to start PowerShell and launch the script:
**Action:** Start a program
**Program/script:** `%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe`
**Add Arguments:** `-ExecutionPolicy Bypass C:\scripts\MoveScript.ps1` (or whatever the delete script is named)

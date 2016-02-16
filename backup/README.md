# Backup Scripts
There are 2 scripts right now:
* **backup.sh** : zips the folders specified in *file_list.txt* and stores them to the USB drive currently connected to the Pi
* **restore.sh** : looks in the USB drive for *backup_<date>.tar.bz*, chooses the latest, copies it to the desktop and unzips it in restored_files folder

##Usage:
* Paste the scripts together anywhere and make the scripts executable with 
> sudo chmod +x backup.sh
> sudo chmod +x restore.sh

* Run the backup script to backup the folders specified in file_list.txt:
> sudo ./backup.sh

* Run the restore script to restore the files back fromt the USB drive
> sudo ./restore.sh

##Notes:
* It automatically mounts the USB drive, does the operation and mounts the USB drive
* The scripts assume that the drives appear as /dev/sda-z][0-9] like /dev/sda1, /dev/sdb2
* The should have the end of lines in UNIX format and not windows format

## License
All software here is released under the [GNU GL3 license.](http://www.gnu.org/licenses/gpl-3.0.txt)

    Originally written by John Cole and Karan Nayan for Dexter Industries.  This software updates your Raspberry Pi Operating System to work with Dexter Industries Hardware
    
    Copyright (C) <2015>  Dexter Industries

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
Here are developer notes and things we don't want to forget from the software work done.

To change the desktop locale to the US:  run sudo dpkg-configure locales  unselect en_GB.UTF-8 and select en_US.UTF-8

========================================================================================

GKSU is used to call python GUI's.  However, GKSU does not work with command line input.  If the user needs to input information (like a y/n or a 1/2) the sh script will hangup and not move forward.  

https://bugs.launchpad.net/ubuntu/+source/gksu/+bug/244930

========================================================================================

Chrome with touchscreens can fail on noVNC:
https://groups.google.com/forum/#!topic/novnc/bOpKeuZCd7s

========================================================================================

This hack help solves permissions for VNC.

http://stackoverflow.com/questions/20286705/tkinter-through-vnc-without-physical-display

You need to run "xhost +" in the command line before running a program in Scratch.
Finally solved the problem: In the desktop shortcut, use "gksu" instead of sudo to call the startup script for Scratch.
Also took "lxterminal" out of some of the calls.  lxterminal starts open new windows, so I removed that.

========================================================================================

If the Pi goes into a continous reboot, try this:
https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=27905

cd ~
ls -A
mv .Xauthority .Xauthority.bkp
reboot

========================================================================================
How we reduce the image size.

When changing an image around you may want to reduce the image size or cut out extra un-used space.  This is how we squeeze a 3GB image onto a 4GB SD card.

We use Ubuntu to reduce the image size of the Raspberry Pi image on disk.  We are essentially eliminating unused space.

1.  Insert your SD Card in the Ubuntu machine.
2.  Open GParted.  Record the number of sectors and sector size.
2.1	In Gparted, unmount both partitions.
2.2	Select "Partition with Extra Space"
2.3	Resize the partition closer in size to the unused area.  Black magic here on how much to shave off, we recommend not shaving more than you need to.

3.  Calculate out the size of the partitions.  In Gparted click "View --> Device Information".  
5.  Note the number of sectors and the sector sizeof the image.  
6.  Calculate out the number of sectors for the new image.  Divide the size of the final image by the sector size to get the number of sectors to copy over.
7.  Run dd.  Be sure you pray beforehand.
8.  sudo dd if=/dev/mmcblk0 of=~/test.img bs=512 count=7250000

	if - file in location.  This is the file we're reducing.
	of - file out location.  This is the file we're creating.  The new reduced file.
	bs - byte sector?  Leave it at 512 for reasons we don't full understand.
	count - sector count.  Multiply by bs to get the number of bytes in your new image.

	This creates test.img in the home directory, with a sector size of 512, and a total img size of 3.5 GB from the SD card located on /dev/mmcblk0

#! /bin/bash
# Copyright Dexter Industries, 2015.
# Install the IR GUI
# Dev Notes:
# Helpful Link on Bin Paths:  http://www.cyberciti.biz/faq/how-do-i-find-the-path-to-a-command-file/

# Removing the following because it's installed in update_all.sh.  If you're running a custom install
# you might need to add these back in.  
#
# sudo apt-get --purge remove python-wxgtk2.8 python-wxtools wx2.8-i18n -y
# sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n --force-yes
# sudo apt-get install python-psutil --force-yes
# sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n --force-yes

# Remove any old shortcut from the desktop.
sudo rm /home/pi/Desktop/ir_start.desktop
# Copy shortcut to desktop.
## NOTE: LIRC GUI changed to advanced comms options
# sudo cp /home/pi/Desktop/GoBox/LIRC_GUI/ir_start.desktop /home/pi/Desktop
# Make shortcut executable
# sudo chmod +x /home/pi/Desktop/ir_start.desktop
# Make ir_start.sh executable.
sudo chmod +x /home/pi/Desktop/GoBox/LIRC_GUI/ir_start.sh
sudo python /home/pi/Desktop/GoBox/LIRC_GUI/setup.py install

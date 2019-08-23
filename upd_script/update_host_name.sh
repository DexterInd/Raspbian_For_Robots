#! /bin/bash
# INSTALLATION FILE:  This file is called from update_all.sh.  It is not part of the actual updating 
# of the hostname.  That function is called from rc.sh (which this file installs!)


# Copy the new rc.local script in place, set permissions. 

sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/rc.local /etc/rc.local
sudo chmod 755 /etc/rc.local	# Change permissions to -rwxr-xr-x

sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/rc.sh
sudo bash /home/pi/di_update/Raspbian_For_Robots/upd_script/rc.sh

#! /bin/bash
# This script will do the updates.  This script can change all the time!
# This script will be changed OFTEN! 

########################################################################
## These Changes to the image are all mandatory.  If you want to run DI
## Hardware, you're going to need these changes.


# set quiet mode so the user isn't told to reboot before the very end
touch /home/pi/quiet_mode
# setting quiet mode
if [ -f /home/pi/quiet_mode ]
then
	quiet_mode=1
else
	quiet_mode=0
fi

HOME=/home/pi
DIUPDATE=di_update
RASPBIAN=Raspbian_For_Robots
RASPBIAN_PATH=$HOME/$DIUPDATE/$RASPBIAN
DESKTOP=Desktop
DESKTOP_PATH=$HOME/$DESKTOP
DEXTER=Dexter
SCRATCH=Scratch_GUI
SCRATCH_PATH=$HOME/$DEXTER/$SCRATCH

source ./functions_libraries.sh

install_copypaste() {
  # put "autocutsel -fork" before the last line in .vnc/xstartup
  xstartup_file='xstartup'
  vnc_dir='/home/pi/.vnc'
  new_str='autocutsel -fork'
  xstartup=$vnc_dir/$xstartup_file

  if file_does_not_exists $xstartup
  then
    touch $xstartup
    add_line_to_end_of_file "xrdb $HOME/.Xresources" $xstartup
    add_line_to_end_of_file "xsetroot -solid grey -cursor_name left_ptr" $xstartup
    add_line_to_end_of_file "/etc/X11/Xsession" $xstartup
  fi

  if ! find_in_file "$new_str" $xstartup
    then
      feedback "Installing copy/paste capabilities"
      insert_before_line_in_file "$new_str" Xsession $xstartup
  fi
}

feedback "--> Begin Update."
feedback "--> ======================================="
sudo dpkg --configure -a
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y	# Get everything updated.  Don't interact with any configuration menus.
							# Referenced from here - http://serverfault.com/questions/227190/how-do-i-ask-apt-get-to-skip-any-interactive-post-install-configuration-steps
feedback "Install Specific Libraries."
sudo apt-get --purge remove python-wxgtk2.8 python-wxtools wx2.8-i18n -y	  			# Removed, this can sometimes cause hangups.  
sudo apt-get remove python-wxgtk3.0 -y

feedback "Purged wxpython tools"
sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n python-psutil --force-yes -y			# Install wx for python for windows / GUI programs.
feedback "Installed wxpython tools"
sudo apt-get remove python-wxgtk3.0 -y
feedback "Python-PSUtil"

sudo apt-get install python3-serial python-serial i2c-tools -y

sudo apt-get purge python-rpi.gpio python3-rpi.gpio -y
# merge all thre install lines into one, as each call to apt-get install 
# takes a while to build the dependency tree
# Oct 27th 2016: add fix for DirtyCow security issue
sudo apt-get install -y python-rpi.gpio python3-rpi.gpio python-picamera python3-picamera python-smbus python3-smbus raspberrypi-kernel
# sudo apt-get install python-psutil -y 		# Used in Scratch GUI, installed a few lines up
sudo pip install -U RPi.GPIO
sudo pip install -U future # for Python 2/3 compatibility

feedback "Installing geany, espeak autocutsel, and piclone"
# geany wasn't always installed by default on Wheezy or Jessie
# autocutsel used for sharing the copy/paste clipboard between VNC and host computer
# espeak used to read text out loud
# piclone used to make copies of the SD card
# new tools from the Foundation

if [ $VERSION -eq '7' ]; then
    sudo apt-get install geany espeak autocutsel -y
else
	sudo apt-get install geany espeak  piclone autocutsel -y
	sudo sed -i '/^Exec/ c Exec=sudo geany %F' /usr/share/raspi-ui-overrides/applications/geany.desktop
fi

sudo adduser pi i2c

########################################################################
# Installing libraries
feedback "Installing some useful libraries"
sudo bash $RASPBIAN_PATH/lib/install.sh


########################################################################
## Kernel Updates
# Enable I2c and SPI.  
feedback "--> Begin Kernel Updates."
feedback "--> Start Update /etc/modules."
feedback "--> ======================================="
feedback " "
sudo sed -i "/i2c-bcm2708/d" /etc/modules
sudo sed -i "/i2c-dev/d" /etc/modules
sudo echo "i2c-bcm2708" >> /etc/modules
sudo echo "i2c-dev" >> /etc/modules
sudo sed -i "/ipv6/d" /etc/modules
sudo echo "ipv6" >> /etc/modules
sudo sed -i "/spi-dev/d" /etc/modules
sudo echo "spi-dev" >> /etc/modules

feedback "--> Start Update Raspberry Pi Blacklist.conf" 	#blacklist spi-bcm2708 #blacklist i2c-bcm2708
feedback "--> ======================================="
feedback " "
sudo sed -i "/blacklist spi-bcm2708/d" /etc/modprobe.d/raspi-blacklist.conf
sudo sed -i "/blacklist i2c-bcm2708/d" /etc/modprobe.d/raspi-blacklist.conf
sudo echo "##blacklist spi-bcm2708" >> /etc/modprobe.d/raspi-blacklist.conf
sudo echo "##blacklist i2c-bcm2708" >> /etc/modprobe.d/raspi-blacklist.conf
# For Raspberry Pi 3.18 kernel and up.
feedback "--> Update Config.txt file"   #dtparam=i2c_arm=on  #dtparam=spi=on
feedback "--> ======================================="
feedback " "
sudo sed -i "/dtparam=i2c_arm=on/d" /boot/config.txt
sudo sed -i "/dtparam=spi=on/d" /boot/config.txt
sudo echo "dtparam=spi=on" >> /boot/config.txt
sudo echo "dtparam=i2c_arm=on" >> /boot/config.txt

# This is really imprtant for the BrickPi!
sudo sed -i "/init_uart_clock=32000000/d" /boot/config.txt
sudo echo "init_uart_clock=32000000" >> /boot/config.txt

# Disable serial over UART
sudo sed -i 's/console=ttyAMA0,115200//' /boot/cmdline.txt  #disable serial login on older images
sudo sed -i 's/console=serial0,115200//' /boot/cmdline.txt  #disable serial login on the Pi3 
sudo sed -i 's/console=tty1//' /boot/cmdline.txt            #console=tty1 can also be there in the cmdline.txt file so remove that 
sudo sed -i 's/kgbdoc=ttyAMA0,115200//' /boot/cmdline.txt
sudo systemctl stop serial-getty@ttyAMA0.service
sudo systemctl disable serial-getty@ttyAMA0.service

feedback "--> End Kernel Updates."

########################################################################
##
# Avahi Updates to Networking Protocols
# Many settings were copied from Google Coder:
# https://github.com/googlecreativelab/coder/blob/master/raspbian-addons/etc/avahi/avahi-daemon.conf
# http://manpages.ubuntu.com/manpages/vivid/man5/avahi-daemon.conf.5.html

sudo rm /etc/avahi/avahi-daemon.conf 														# Remove Avahi Config file.
sudo cp $RASPBIAN_PATH/upd_script/avahi-daemon.conf /etc/avahi 		# Copy new Avahi Config File.
sudo chmod +x /etc/avahi/avahi-daemon.conf 													# Set permissions for avahi config file.

sudo modprobe ipv6

########################################################################
##
# Cleanup the Desktop
feedback "--> Desktop cleanup."
feedback "--> ======================================="
feedback " "
sudo rm $DESKTOP_PATH/ocr_resources.desktop 		# Not sure how this Icon got here, but let's take it out.
sudo rm $DESKTOP_PATH/python-games.desktop 		# Not sure how this Icon got here, but let's take it out.


# Call fetch.sh - This updates the Github Repositories, installs necessary dependencies.
feedback "--> Begin Update Dexter Industries Software Packages."
feedback "--> ======================================="
feedback " "
# sh will not work here. Bash is required
sudo bash $RASPBIAN_PATH/upd_script/fetch.sh

# Install Scratch GUI
sudo bash $SCRATCH_PATH/install_scratch_start.sh

# Enable LRC Infrared Control on Pi.
feedback "--> Enable LRC Infrared Control on Pi."
feedback "--> ======================================="
feedback " "
sudo sh $DESKTOP_PATH/GoPiGo/Software/Python/ir_remote_control/script/ir_install.sh
sudo chmod +x $DESKTOP_PATH/GoPiGo/Software/Python/ir_remote_control/gobox_ir_receiver_libs/install.sh
sudo bash $DESKTOP_PATH/GoPiGo/Software/Python/ir_remote_control/gobox_ir_receiver_libs/install.sh

# Update background image - Change to dilogo.png
# These commands don't work:  sudo rm /etc/alternatives/desktop-background  ;;  sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.jpg /etc/alternatives/
feedback "--> Update the background image on LXE Desktop."
feedback "--> ======================================="
feedback " "
sudo rm /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png
sudo cp $RASPBIAN_PATH/dexter_industries_logo.png /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png


########################################################################
## These Changes to the image are all optional.  Some users may not want
## these changes.  They should be offered ala-cart.

# Update Wifi Interface
feedback "--> Update wifi interface."
feedback "--> ======================================="
feedback " "
sudo apt-get install raspberrypi-net-mods -y	# Updates wifi configuration.  Does it wipe out network information?

# Setup Apache
feedback "--> Install Apache. and PHP"
feedback "--> ======================================="
feedback " "

sudo apt-get install avahi-daemon avahi-utils -y  # Added to help with avahi issues.  2016.01.03
sudo apt-get install apache2 php5 libapache2-mod-php5 -y

sudo chmod +x $RASPBIAN_PATH/upd_script/wifi/wifi_disable_sleep.sh
sudo sh $RASPBIAN_PATH/upd_script/wifi/wifi_disable_sleep.sh

# Setup Webpage
feedback "--> Set up webpage."
feedback "--> ======================================="
feedback " "
sudo rm -r /var/www
sudo cp -r $RASPBIAN_PATH/www /var/
sudo chmod +x /var/www/index.php
sudo chmod +x /var/www/css/main.css

## Now, if we are running Jessie, we need to move everything
## into a new subdirectory.
## Get the Debian Version we have installed.
VERSION=$(sed 's/\..*//' /etc/debian_version)
# echo "Version: $VERSION"
if [ $VERSION -eq '7' ]; then
  feedback "Version 7 found!  You have Wheezy!"
elif [ $VERSION -eq '8' ]; then
  feedback "Version 8 found!  You have Jessie!"
  # If we found Jesse, the proper location of the html files is in
  # /var/www/html
  sudo mkdir /var/www/html
  sudo mv -v /var/www/* /var/www/html/
  sudo chmod +x /var/www/html/index.php
  sudo chmod +x /var/www/html/css/main.css  
fi

# echo $VERSION


# Setup Shellinabox
feedback "--> Set up Shellinabox."
feedback "--> ======================================="
feedback " "
sudo apt-get install shellinabox -y

# disable requirement for SSL for shellinaboxa 
# adding after line 41, which is approximately where similar arguments are found.
# it could really be anywhere in the file - NP
sudo sed -i '/SHELLINABOX_ARGS=/d' /etc/init.d/shellinabox
sudo sed -i '41 i\SHELLINABOX_ARGS="--disable-ssl"' /etc/init.d/shellinabox


# Setup noVNC
feedback "--> Set up screen."
feedback "--> ======================================="
feedback " "
sudo apt-get install screen -y
feedback "--> Set up noVNC"
feedback "--> ======================================="
feedback " "
cd /usr/local/share/
feedback "--> Clone noVNC."
sudo git clone git://github.com/DexterInd/noVNC
cd noVNC
sudo git pull
sudo cp vnc_auto.html index.html


# VNC Start on boot
# reading VERSION again, in case lines get moved, or deleted above.
# better safe
VERSION=$(sed 's/\..*//' /etc/debian_version)
# echo "Version: $VERSION"
# setting start-on-boot for Wheezy. Those two scripts are not needed for Jessie
# Wheezy 
if [ $VERSION -eq '7' ]; then
  feedback "Version 7 found!  You have Wheezy!"
  cd /etc/init.d/
  sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncboot --no-check-certificate
  sudo chmod 755 vncboot
  sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncproxy --no-check-certificate
  sudo chmod 755 vncproxy 
  # why default 98? I can't find what it's supposed to do - NP
  sudo update-rc.d vncproxy defaults 98
  sudo update-rc.d vncproxy defaults
  sudo update-rc.d vncproxy enable
  sudo update-rc.d vncboot defaults
  sudo update-rc.d vncboot enable
  cd /usr/local/share/noVNC/utils
  sudo ./launch.sh --vnc localhost:5900 &

#jessie
elif [ $VERSION -eq '8' ]; then
  feedback "Version 8 found!  You have Jessie!"
  pushd /home/pi

  # if we have a local copy of novnc.service, get rid of it before downloading a new one
  if [ -e /home/pi/novnc.service ]
  then
    sudo rm novnc.service
    feedback "removing local copy of novnc.service"
  fi

  sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/novnc.service
  sudo mv novnc.service /etc/systemd/system/novnc.service
  sudo systemctl daemon-reload
  sudo systemctl enable novnc.service
  sudo systemctl start novnc.service
  popd
fi

# Change permissions so you can execute from the desktop
####  http://thepiandi.blogspot.ae/2013/10/can-python-script-with-gui-run-from.html
####  http://superuser.com/questions/514688/sudo-x11-application-does-not-work-correctly

feedback "Change bash permissions for desktop."
if grep -Fxq "xhost +" /home/pi/.bashrc
then
	#Found it, do nothing!
	echo "Found xhost in .bashrc"
else
	sudo echo "xhost +" >> /home/pi/.bashrc
fi

feedback "--> Finished setting up noVNC"
feedback "--> ======================================="
feedback "--> !"
feedback "--> !"
feedback "--> !"
feedback "--> ======================================="
feedback " "

########################################################################
# ensure the Scratch examples are reachable via Scratch GUI
# this is done by using soft links
########################################################################
bash $RASPBIAN_PATH/upd_script/upd_scratch_softlinks.sh

# This pause is placed because we'll overrun the if statement below if we don't wait a few seconds. 
sleep 10

########################################################################
## Last bit of house cleaning.

# Setup Hostname Changer
feedback "--> Set up Hostname Changer."
feedback "--> ======================================="
feedback " "
sudo chmod +x $RASPBIAN_PATH/upd_script/update_host_name.sh		# 1 - Run update_host_name.sh
sudo sh $RASPBIAN_PATH/upd_script/update_host_name.sh			# 2 - Add change to rc.local to new rc.local that checks for hostname on bootup.
feedback "--> End hostname change setup."

# Install Samba
feedback "--> Start installing Samba."
feedback "--> ======================================="
feedback " "
sudo chmod +x $RASPBIAN_PATH/upd_script/install_samba.sh
sudo sh $RASPBIAN_PATH/upd_script/install_samba.sh
feedback "--> End installing Samba."

# install the copy/paste functionality in vnc
# assumes that apt-get install autocutsel is done near the top
install_copypaste

# Install Spy vs sPi Startup.
# sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/spivsspi/SpyVsSpy_install.sh
# sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/spivsspi/SpyVsSpy_install.sh

# Remove Spy vs Spi 
sudo bash $RASPBIAN_PATH/upd_script/spivsspi/SpyVsSpi_remove.sh

# Install Backup
feedback "--> Start installing Backup."
feedback "--> ======================================="
feedback " "
sudo chmod +x $RASPBIAN_PATH/backup/backup.sh
sudo chmod +x $RASPBIAN_PATH/backup/restore.sh
sudo chmod +x $RASPBIAN_PATH/backup/call_backup.sh
sudo chmod +x $RASPBIAN_PATH/backup/call_restore.sh
sudo chmod +x $RASPBIAN_PATH/backup/run_backup.sh
sudo chmod +x $RASPBIAN_PATH/backup/file_list.txt
sudo chmod +x $RASPBIAN_PATH/backup/backup_gui.py
feedback "--> End installing Backup."

feedback "--> Update for RPi3."
# Run the update script for updating overlays for Rpi3.
sudo chmod +x $RASPBIAN_PATH/pi3/Pi3.sh
sudo sh $RASPBIAN_PATH/pi3/Pi3.sh

# remove wx version 3.0 - which gets pulled in by various other libraries
# it creates graphical issues in our Python GUI
sudo apt-get remove python-wxgtk3.0 -y

# Update Cinch, if it's installed.
# check for file /home/pi/cinch, if it is, call cinch setup.
if [ ! -f /home/pi/cinch ]; then
    echo "No Cinch Found."
else
    echo "Found cinch, running Cinch install."
    cd $RASPBIAN_PATH/upd_script/wifi
    sudo ./cinch_setup.sh
fi

feedback "--> Begin cleanup."
sudo apt-get clean -y		# Remove any unused packages.
sudo apt-get autoremove -y 	# Remove unused packages.
efeedbackcho "--> End cleanup."

feedback "--> Update version on Desktop."
#Finally, if everything installed correctly, update the version on the Desktop!
cd $DESKTOP_PATH
rm Version
rm version.desktop
sudo cp $RASPBIAN_PATH/desktop/version.desktop $DESKTOP_PATH
sudo chmod +x $DESKTOP_PATH/version.desktop


# edition version file to reflect which Rasbpian flavour
VERSION=$(sed 's/\..*//' /etc/debian_version)
# echo "Version: $VERSION"
if [ $VERSION -eq '8' ]; then
  feedback "Modifying Version file to reflect Jessie distro"
  sudo sed -i 's/Wheezy/Jessie/g' $RASPBIAN_PATH/Version
fi

rm /home/pi/quiet_mode

feedback "--> ======================================="
feedback "--> ======================================="
feedback "  _    _               _           _                         ";
feedback " | |  | |             | |         | |                        ";
feedback " | |  | |  _ __     __| |   __ _  | |_    ___                ";
feedback " | |  | | | '_ \   / _\ |  / _\ | | __|  / _ \               ";
feedback " | |__| | | |_) | | (_| | | (_| | | |_  |  __/               ";
feedback "  \____/  | .__/   \__,_|  \__,_|  \__|_ \___|    _          ";
feedback "  / ____| | |                         | |        | |         ";
feedback " | |      |_|__    _ __ ___    _ __   | |   ___  | |_    ___ ";
feedback " | |       / _ \  |  _ \  _ \ |  _ \  | |  / _ \ | __|  / _ \ ";
feedback " | |____  | (_) | | | | | | | | |_) | | | |  __/ | |_  |  __/ ";
feedback "  \_____|  \___/  |_| |_| |_| | .__/  |_|  \___|  \__|  \___| ";
feedback "                              | |                            ";
feedback "                              |_|                            ";
feedback "--> Installation Complete."
feedback "--> "
feedback "--> "
feedback "--> Press the Exit button and the Pi will automatically reboot."

#! /bin/bash
#
# Add LX Desktop And Raspberry Pi to Jessie Lite
# by John Cole // Dexter Industries
#
###################################################
#
# To Run:
# sudo chmod +x jessie-lite-upgrade.sh
# sudo ./jessie-lite-upgrade.sh
#
###################################################

###################################################
##
## Take Jessie Lite to Raspbian
##
###################################################

sudo apt-get update
sudo apt-get install xserver-xorg-core libllvm3.7 -y
sudo apt-get install libgtk2.0-common -y
sudo apt-get install lightdm-gtk-greeter -y
sudo apt-get install libpam-systemd -y
sudo apt-get install consolekit -y
sudo apt-get install xserver-xorg -y
sudo apt-get install lightdm -y
sudo apt-get install lxde-common -y
sudo apt-get install lxsession lxpolkit lxsession-edit lxde-common lxsession -y

sudo apt-get install galculator gpicview leafpad lxappearance lxappearance-obconf lxde-core lxde-icon-theme lxinput lxrandr xarchiver alsamixergui clipit deluge transmission-gtk evince-gtk gnome-disk-utility gnome-mplayer gnome-system-tools gucharmap iceweasel lxmusic audacious menu-xdg usermode wicd network-manager-gnome -y
sudo apt-get install midori epiphany-browser xpdf -y
sudo apt-get install LXDE xinit -y
sudo apt-get dist-upgrade -y
sudo apt-get install raspberrypi-net-mods -y
sudo apt-get install wpagui -y
sudo apt-get install scratch -y
sudo apt-get install apache2 -y
sudo apt-get install php5 libapache2-mod-php5 -y

sudo apt-get install xfonts-100dpi xfonts-75dpi xfonts-scalable -y


sudo apt-get install rpi-update -y

sudo apt-get install avahi-autoipd tightvncserver bc python-imaging python-pexpect python-renderpm python-reportlab python-reportlab-accel python-tk python3-tk idle idle-python2.7 idle3 nodejs nodejs-legacy pypy-setuptools pypy-upstream pypy-upstream-dev pypy-upstream-doc blt bluetooth -y


sudo apt-get update
sudo apt-get upgrade
sudo apt-get clean

## Now Custom Modifications for Dexter Industries Raspbian for Robots.  
sudo apt-get install git -y
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/update_backup.sh /home/pi
sudo chmod +x update_backup.sh
sudo ./update_backup.sh

cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/GoPiGo.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/GrovePi.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_Python.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/ArduBerry.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_Scratch.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_Python.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_C.git
cd /home/pi/Desktop

sudo sh /home/pi/di_update/Raspbian_For_Robots/update_master.sh


##################################################################
##
## After you run this run the update software on the Desktop.
##
##################################################################

# Changes by Hand:
# Setup Desktop to Automatically Boot Login
# Install TightVNC Server and Set to Run at Boot.  https://learn.adafruit.com/adafruit-raspberry-pi-lesson-7-remote-control-with-vnc/running-vncserver-at-startup
# Setup Autoboot:  http://www.penguintutor.com/raspberrypi/tightvnc

#Suggested Packages along the Way: 
#python-idna
#
#  ispell aspell hunspell wordlist cdtool setcd gconf-defaults-service obex-data-server isoquery libdigest-hmac-perl
#  libgssapi-perl libfm-tools nautilus-actions libgd-tools gphoto2 gtkam libvisual-0.4-plugins gstreamer-codec-install
#  gnome-codec-install gstreamer0.10-tools gstreamer0.10-plugins-base libdata-dump-perl libusbmuxd-tools libcrypt-ssleay-perl
#  libauthen-ntlm-perl lsb lxlauncher iceweasel www-browser lxde gpicview menu fonts-dejavu libxml2-dev tint2 openbox-menu
#  openbox-gnome-session openbox-kde-session xfsprogs reiserfsprogs exfat-utils btrfs-tools mdadm cryptsetup-bin mesa-utils
#  xfishtank xdaliclock xscreensaver-gl fortune qcam streamer gdm3 kdm-gdmcompat

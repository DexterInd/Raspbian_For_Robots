#
# To Setup and Run:
# cd /home/pi/
# sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie-heavy-upgrade.sh
# sudo bash jessie-heavy-upgrade.sh
#
###################################################

###################################################
# remove all extraneous packages from Jessie 
# trying to gain as much space as possible
# change CleoQc to DexterInd when doing PR
###################################################
rm ./jessie_cleanup.sh  # just making sure there isn't one yet
wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/jessie_cleanup.sh
chmod +x ./jessie_cleanup.sh
./jessie_cleanup.sh
rm ./jessie_cleanup.sh


###################################################
##
## Take "Jessie on a Diet" to Raspbian
##
###################################################

sudo apt-get update -y
sudo apt-get upgrade -y

# is dist-upgrade necessary ? 
# sudo apt-get dist-upgrade -y

# apache necessary for noVNC
sudo apt-get -y install avahi-daemon avahi-utils
sudo rm /etc/avahi/avahi-daemon.conf 														# Remove Avahi Config file.
sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/avahi-daemon.conf /etc/avahi 		# Copy new Avahi Config File.
sudo chmod +x /etc/avahi/avahi-daemon.conf 
sudo apt-get install apache2 -y
sudo apt-get install php5 libapache2-mod-php5 -y
sudo apt-get install raspberrypi-net-mods -y
sudo apt-get install wpagui -y

# scratch is already there - leaving here for documentation purposes
# with Jessie we need nuscratch anyway
sudo apt-get install scratch -y

# breaking this down in four lines for readability
# tightvncserver moved to Raspbian_For_Robots_Flavor.sh
sudo apt-get install avahi-autoipd bc python-imaging python-pexpect python-renderpm -y
sudo apt-get install python-reportlab python-reportlab-accel  -y

# the following are all installed on Jessie. Leaving here for documentation purposes
sudo apt-get install python-tk python3-tk idle idle-python2.7 idle3 nodejs nodejs-legacy -y
sudo apt-get install pypy-setuptools pypy-upstream pypy-upstream-dev pypy-upstream-doc blt -y
sudo apt-get install bluetooth -y

## Now Custom Modifications for Dexter Industries Raspbian for Robots.  
sudo apt-get install git -y # already on Jessie
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/update_backup.sh /home/pi
sudo chmod +x update_backup.sh
sudo ./update_backup.sh
rm ./update_backup.sh -y

###################################################
# give Raspbian its flavor. After this, host will be dex, and pi password will be robots1234
# Samba will also be installed with password set to robots1234
# Tightvncserver, noVNC, and Shellinabox get installed at this stage
###################################################
rm ./Raspbian_for_Robots_Flavor.sh
wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/Raspbian_for_Robots_Flavor.sh
chmod +x ./Raspbian_for_Robots_Flavor.sh
./Raspbian_for_Robots_Flavor.sh
rm ./Raspbian_for_Robots_Flavor.sh

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


sudo apt-get clean
sudo apt-get autoremove -y 

##################################################################
##
## After you run this run the update software on the Desktop.
##
##################################################################

# Changes by Hand:
# Change background desktop to white.

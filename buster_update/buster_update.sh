#
# To Setup and Run:
# cd /home/pi/
# sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/buster_update.sh
# sudo bash buster-update.sh
#
###################################################

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y novnc websockify


# To be done before running this file
# mkdir /home/pi/di_update
# cd /home/pi/di_update
# git clone https://github.com/dexterind/Raspbian_For_Robots

# apache necessary for noVNC
sudo apt -y install avahi-daemon avahi-utils
# Overwrite Avahi Config file.
sudo cp -f /home/pi/di_update/Raspbian_For_Robots/upd_script/avahi-daemon.conf /etc/avahi 		# Copy new Avahi Config File.
sudo chmod +x /etc/avahi/avahi-daemon.conf
sudo apt install  apache2 php7.3 -y
sudo apt install raspberrypi-net-mods wpagui -y



# breaking this down in four lines for readability
# tightvncserver moved to Raspbian_For_Robots_Flavor.sh
sudo apt install avahi-autoipd bc python-pil python-pexpect python-renderpm -y
sudo apt install python-reportlab python-reportlab-accel  -y

#enable php on Apache
sudo a2enmod php7.3
sudo systemctl restart apache2

# while we don't need mariadb, it is kind of a standard so let's offer it
echo "Installing MariaDB"
sudo apt install -y mariadb-server mariadb-client

# Install novnc
bash novnc.sh

##################################################################
#
# install Dexter Robot libraries
#
##################################################################

mkdir -p /home/pi/Dexter

echo "######################################################"
echo "INSTALLING ROBOTS"
echo "######################################################"

curl -kL dexterindustries.com/update_gopigo3 | bash
curl -kL dexterindustries.com/update_brickpi3 | bash
curl -kL dexterindustries.com/update_grovepi | bash
curl -kL dexterindustries.com/update_pivotpi | bash
curl -kL dexterindustries.com/update_sensors | bash


sudo apt clean
sudo apt autoremove -y

###################################################
# give Raspbian its flavor. After this, host will be dex, and pi password will be robots1234
# Samba will also be installed with password set to robots1234
# noVNC, and Shellinabox get installed at this stage
###################################################
sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo_transparent_bg.png  /usr/share/rpd-wallpaper

bash /home/pi/di_update/Raspbian_For_Robots/buster_update/Raspbian_for_Robots_Buster_Flavor.sh


###################################################
# EXPAND on first boot
###################################################
touch /home/pi/first_boot
if ! grep -q "sudo bash /home/pi/di_update/Rasbian_For_Robots/expand_on_first_boot.sh" /etc/rc.local
then
    sudo sed -i '/exit 0/i sudo bash /home/pi/di_update/Rasbian_For_Robots/expand_on_first_boot.sh' /etc/rc.local
fi

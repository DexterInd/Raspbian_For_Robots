######################################################################
# this script changes the logos:
# 1. the desktop background logo to Dexter
# 2. the top left icon to a small Dexter
# 3. background color to white
######################################################################

# Update background image - Change to dilogo.png
# These commands don't work: 
#  sudo rm /etc/alternatives/desktop-background  
#  sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.jpg /etc/alternatives/

echo "--> Update the background image on LXE Desktop."
echo "--> ======================================="
echo " "
#sudo rm /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png
sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.png /usr/share/raspberrypi-artwork/dexter_industries_logo.png
sudo sed -i '/^wallpaper=/s/wallpaper=.*/wallpaper=\/usr\/share\/raspberrypi-artwork\/dexter_industries_logo.png/g' /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf


# update top left icon
sudo cp /home/pi/di_update/Raspbian_For_Robots/dex.png /usr/share/raspberrypi-artwork/dex.png
sudo sed -i 's/raspitr/dex/g' /home/pi/.config/lxpanel/LXDE-pi/panels/panel


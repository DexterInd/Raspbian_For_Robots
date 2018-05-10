#! /bin/bash

source $HOME/Dexter/lib/Dexter/script_tools/functions_library.sh
pushd $HOME/di_update/Raspbian_For_Robots/VNC >/dev/null

# this installs websockify, novnc, shellinabox
# assumed already installed: apache2 and tightvncserver
# it also installs all required services

# install noVNC on a new image
source bash ./install_novnc.sh


# Setup Shellinabox
# feedback "--> Set up Shellinabox."
# feedback "--> ======================================="
# feedback " "
# sudo apt-get install shellinabox -y
# sudo /lib/systemd/systemd-sysv-install enable shellinabox
# sudo service shellinabox start

# echo "--> Set up screen."
# echo "--> ======================================="
# echo " "
# # screen currently installed but not used. 
# sudo apt-get install screen -y 

feedback "Start noVNC service"
sudo cp novnc.service /etc/systemd/system/novnc.service
sudo chown root:root /etc/systemd/system/novnc.service
sudo systemctl daemon-reload
sudo systemctl enable novnc.service

feedback "--> restarting the apache server"
sudo /etc/init.d/apache2 reload


# install systemd service

# sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/novnc.service
# sudo cp novnc.service /etc/systemd/system/novnc.service
# sudo chown root:root /etc/systemd/system/novnc.service
#sudo chmod +x /etc/systemd/system/novnc.service #system complains about it being marked executable. Fine, be that way.

echo "############################################################"
#sudo systemctl daemon-reload
#sudo systemctl enable novnc.service
echo "############################################################"

# The xhost is needed so that programs run with sudo have right access
# to the X display
# Change permissions so you can execute from the desktop
####  http://thepiandi.blogspot.ae/2013/10/can-python-script-with-gui-run-from.html
####  http://superuser.com/questions/514688/sudo-x11-application-does-not-work-correctly

echo "Change bash permissions for desktop."

if grep -Fxq "xhost +" /home/pi/.bashrc
then
	#Found it, do nothing!
	echo "Found xhost in .bashrc"
else
	sudo echo "xhost + >/dev/null" >> /home/pi/.bashrc
fi

popd >/dev/null
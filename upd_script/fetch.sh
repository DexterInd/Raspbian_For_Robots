#! /bin/bash
# This script updates the the code repos on Raspbian for Robots.

# GoPiGo Update
echo "--> Start GoPiGo Update."
echo "----------"
# Un Changed the process here: move from git fetch to just delete the directory, and then clone back in.
cd /home/pi/Desktop/GoPiGo    
sudo git fetch origin   
sudo git reset --hard  
sudo git merge origin/master

# cd /home/pi/Desktop # sudo rm -r GoPiGo # sudo git clone https://github.com/DexterInd/GoPiGo.git

cd Setup
echo "--> UPDATING LIBRARIES"
echo "------------------"
sudo chmod +x install.sh
sudo ./install.sh

# Install GoPiGo Line Follower Calibration
sudo rm /home/pi/Desktop/line_follow.desktop
sudo cp /home/pi/Desktop/GoPiGo/Software/Python/line_follower/line_follow.desktop /home/pi/Desktop/
sudo chmod +x /home/pi/Desktop/line_follow.desktop
sudo chmod +x /home/pi/Desktop/GoPiGo/Software/Python/line_follower/line_sensor_gui.py

echo "--> Install Scratch dependency ScratchPy."
cd /home/pi/Desktop/GoPiGo/Software/Scratch
sudo git clone https://github.com/DexterInd/scratchpy.git
cd scratchpy
sudo make install

#GoPiGo Scratch Permissions
#echo "--> Install Scratch Shortcuts and Permissions."
#sudo rm /home/pi/Desktop/GoPiGo_Scratch_Start.desktop  					# Delete old icons off desktop
#sudo cp /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGo_Scratch_Start.desktop /home/pi/Desktop	# Move icons to desktop
sudo chmod +x /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGoScratch_debug.sh					# Change script permissions
sudo chmod +x /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGo_Scratch_Start.sh					# Change script permissions
sudo chmod -R 777 /usr/share/scratch/Projects/


# BrickPi Update
echo "--> Start BrickPi Update."
echo "----------"
cd /home/pi/Desktop/BrickPi
sudo git fetch origin
git reset --hard
sudo git merge origin/master

# BrickPi_Python Update
echo "--> Start BrickPi_Python Update."
echo "----------"
cd /home/pi/Desktop/BrickPi_Python
sudo git fetch origin
git reset --hard
sudo git merge origin/master

sudo apt-get install python-setuptools
# Remove Python Packages
cd /home/pi/Desktop/BrickPi_Python/
sudo python /home/pi/Desktop/BrickPi_Python/setup.py install

# BrickPi_Scratch Update
echo "--> Start BrickPi_Scratch Update."
echo "----------"
cd /home/pi/Desktop/BrickPi_Scratch
sudo git fetch origin
git reset --hard
sudo git merge origin/master

sudo rm -r scratchpy
git clone https://github.com/DexterInd/scratchpy
cd scratchpy
sudo make install

cd ..
cd BrickPi_Scratch_Scripts
sudo chmod +x BrickPi_Scratch_Start.sh
sudo chmod +x BrickPiScratch_debug.sh

# BrickPi_C Update
echo "--> Start BrickPi_C Update."
echo "----------"
cd /home/pi/Desktop/BrickPi_C
sudo git fetch origin
git reset --hard
sudo git merge origin/master

# Arduberry Update
echo "--> Start Arduberry Update."
echo "----------"
cd /home/pi/Desktop/ArduBerry
sudo git fetch origin
git reset --hard
sudo git merge origin/master

sudo chmod +x /home/pi/Desktop/ArduBerry/script/install.sh
sudo sh /home/pi/Desktop/ArduBerry/script/install.sh

# GrovePi Update
echo "--> Start GrovePi Update."
echo "----------"
cd /home/pi/Desktop/GrovePi
sudo git fetch origin
git reset --hard
sudo git merge origin/master
echo "--> Start GrovePi update install."
echo "----------"
cd /home/pi/di_update/Raspbian_For_Robots/upd_script
sudo chmod +x update_GrovePi.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/update_GrovePi.sh

# GrovePi Scratch Setup
# sudo rm /home/pi/Desktop/GrovePi_Scratch_Start.desktop  					# Delete old icons off desktop
# sudo cp /home/pi/Desktop/GrovePi/Software/Scratch/GrovePi_Scratch_Scripts/GrovePi_Scratch_Start.desktop /home/pi/Desktop	# Move icons to desktop
sudo chmod +x /home/pi/Desktop/GrovePi/Software/Scratch/GrovePi_Scratch_Scripts/GrovePiScratch_debug.sh						# Change script permissions
sudo chmod +x /home/pi/Desktop/GrovePi/Software/Scratch/GrovePi_Scratch_Scripts/GrovePi_Scratch_Start.sh					# Change script permissions

# Install DexterEd Software
echo "--> Install DexterEd Software"
sudo rm -r /home/pi/Desktop/DexterEd
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/DexterEd.git


# Install GoBox Software
echo "--> Install GoBox Software"
sudo rm -r /home/pi/Desktop/GoBox
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/GoBox.git
sudo chmod +x /home/pi/Desktop/GoBox/Scratch_GUI/install_scratch_start.sh
sudo sh /home/pi/Desktop/GoBox/Scratch_GUI/install_scratch_start.sh

sudo chmod +x /home/pi/Desktop/GoBox/LIRC_GUI/install_ir_start.sh
sudo sh /home/pi/Desktop/GoBox/LIRC_GUI/install_ir_start.sh
cp /home/pi/di_update/Raspbian_For_Robots/advanced_communication_options/advanced_comms_options.desktop /home/pi/Desktop

sudo cp /home/pi/di_update/Raspbian_For_Robots/rpi_config_menu_gui/rc_gui.desktop /usr/share/applications/rc_gui.desktop

# Install GoBox Troubleshooting Software
sudo rm /home/pi/Desktop/Troubleshooting_Start.desktop
sudo chmod +x /home/pi/Desktop/GoBox/Troubleshooting_GUI/install_troubleshooting_start.sh
sudo sh /home/pi/Desktop/GoBox/Troubleshooting_GUI/install_troubleshooting_start.sh

#########################################
# Install All Python Scripts

#########################################
# BrickPi Python Installation
cd /home/pi/Desktop/BrickPi_Python/
sudo python setup.py install --record files.txt

# This will cause all the installed files to be printed to that directory.
# Remove the files.txt

sudo cat files.txt | xargs sudo rm -rf
sudo rm files.txt
sudo python setup.py install

##########################################
#GoPiGo Python Installation
cd /home/pi/Desktop/GoPiGo/Software/Python/
sudo python setup.py install --record files.txt
sudo cat files.txt | xargs sudo rm -rf
sudo rm files.txt
sudo python setup.py install

##########################################
# GoPiGo Line Follower Installation
# TBA

#########################################
#  GrovePi
cd /home/pi/Desktop/GrovePi/Software/Python/
sudo python setup.py install --record files.txt
sudo cat files.txt | xargs sudo rm -rf
sudo rm files.txt
sudo python setup.py install

echo "--> Done updating Dexter Industries Github repos!"

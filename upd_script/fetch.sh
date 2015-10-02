#! /bin/bash
# This script updates the the code repos on Raspbian for Robots.

# GoPiGo Update
echo "--> Start GoPiGo Update."
echo "----------"
cd /home/pi/Desktop/GoPiGo
sudo git fetch origin
git reset --hard
sudo git merge origin/master
cd Setup
echo "--> UPDATING LIBRARIES"
echo "------------------"
sudo chmod +x install.sh
sudo ./install.sh

echo "--> Install Scratch dependency ScratchPy."
cd Desktop/GoPiGo/Software/Scratch
sudo git clone https://github.com/DexterInd/scratchpy.git
cd scratchpy
sudo make install

#GoPiGo Scratch Permissions
#echo "--> Install Scratch Shortcuts and Permissions."
#sudo rm /home/pi/Desktop/GoPiGo_Scratch_Start.desktop  					# Delete old icons off desktop
#sudo cp /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGo_Scratch_Start.desktop /home/pi/Desktop	# Move icons to desktop
sudo chmod +x /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGoScratch_debug.sh					# Change script permissions
sudo chmod +x /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGo_Scratch_Start.sh					# Change script permissions

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

echo "--> Done updating Dexter Industries Github repos!"

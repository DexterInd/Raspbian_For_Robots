#! /bin/bash
# Copyright Dexter Industries, 2015.
# Install the Troubleshooting GUI.
# Dev Notes:
# Helpful Link on Bin Paths:  http://www.cyberciti.biz/faq/how-do-i-find-the-path-to-a-command-file/
# needs to be sourced from here when we call this as a standalone

PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots

PIHOME=/home/pi
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots
DEXTER=Dexter
LIB=lib
LIB_PATH=$PIHOME/$DEXTER/$LIB
DEXTERLIB_PATH=$LIB_PATH/$DEXTER
TROUBLESHOOTING=Troubleshooting_GUI
TROUBLESHOOTING_PATH=$DEXTERLIB_PATH/$TROUBLESHOOTING

curl --silent https://raw.githubusercontent.com/DexterInd/script_tools/master/install_script_tools.sh | bash
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh
create_folder $PIHOME/$DEXTER
create_folder $PIHOME/$DEXTER/$LIB
create_folder $PIHOME/$DEXTER/$LIB/$DEXTER
create_folder $PIHOME/$DEXTER/$LIB/$DEXTER/$TROUBLESHOOTING

if ! quiet_mode
then
	# updated from --force-yes to --yes --force-yes (2nd answer here: http://superuser.com/questions/164553/automatically-answer-yes-when-using-apt-get-install)
	sudo apt-get --purge remove python-wxgtk2.8 python-wxtools wx2.8-i18n -y
	sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n --yes --force-yes
	sudo apt-get install python-psutil --yes --force-yes
	sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n --yes --force-yes
fi

sudo cp -f $RASPBIAN/$TROUBLESHOOTING/* $TROUBLESHOOTING_PATH
# Copy shortcut to desktop.
#sudo rm /home/pi/Desktop/Troubleshooting_Start.desktop
# by using -f we force the copy
sudo cp -f $TROUBLESHOOTING_PATH/Troubleshooting_Start.desktop /home/pi/Desktop
# Make shortcut executable
sudo chmod +x /home/pi/Desktop/Troubleshooting_Start.desktop

delete_folder /home/pi/GoBox/Troubleshooting
# Make troubleshooting_start executable.
sudo chmod +x /home/pi/Desktop/GoBox/Troubleshooting_GUI/Troubleshooting_Start.sh
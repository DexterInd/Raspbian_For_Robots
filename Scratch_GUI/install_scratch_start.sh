#! /bin/bash
# Copyright Dexter Industries, 2017.
# Install the Scratch GUI.
# Dev Notes:
# Helpful Link on Bin Paths:  http://www.cyberciti.biz/faq/how-do-i-find-the-path-to-a-command-file/


PIHOME=/home/pi
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots
DEXTER=Dexter
LIB=lib
LIB_PATH=$PIHOME/$DEXTER/$LIB
DEXTERLIB_PATH=$LIB_PATH/$DEXTER
SCRATCH=Scratch_GUI
SCRATCH_PATH=$DEXTERLIB_PATH/$SCRATCH

curl -kL dexterindustries.com/update_tools | sudo bash
source $PIHOME/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

create_folder $PIHOME/$DEXTER
create_folder $PIHOME/$DEXTER/$LIB
create_folder $PIHOME/$DEXTER/$LIB/$DEXTER
create_folder $PIHOME/$DEXTER/$LIB/$DEXTER/$SCRATCH

pushd $SCRATCH_PATH > /dev/null

feedback "Installing Scratch Environment"
cp -f $RASPBIAN/$SCRATCH/* $SCRATCH_PATH

if [ -d $PIHOME/Desktop/GoBox/Scratch_GUI ] ; then
	sudo rm -r $PIHOME/Desktop/GoBox/Scratch_GUI
fi

pushd $LIB_PATH > /dev/null
delete_folder scratchpy
git clone --quiet --depth=1 https://github.com/DexterInd/scratchpy
cd scratchpy
sudo make install > /dev/null
popd > /dev/null

# Copy shortcut to desktop.
feedback "Installing Scratch on the desktop"
sudo cp -f $SCRATCH_PATH/Scratch_Start.desktop $PIHOME/Desktop
sudo cp -f $SCRATCH_PATH/Scratch_Start.desktop /usr/share/applications/
sudo lxpanelctl restart
# Make shortcut executable
sudo chmod +x $PIHOME/Desktop/Scratch_Start.desktop							# Desktop shortcut permissions.

# sudo rm /usr/share/applications/scratch.desktop															# Remove the Scratch Start button in the Menu

######
# Added these to solve the menu problem of scratch.  Then removed them.  
# These are removed for now, the call up the Scratch Gui, not the scratch start.
# sudo rm /usr/share/raspi-ui-overrides/applications/scratch.desktop										# Remove the Scratch Start button in the Menu
# sudo cp /home/pi/$DEXTER/Scratch_GUI/Scratch_Start.desktop /usr/share/applications/scratch.desktop						# Copy the Scratch_Start to the Menu
# sudo cp /home/pi/$DEXTER/Scratch_GUI/Scratch_Start.desktop /usr/share/raspi-ui-overrides/applications/scratch.desktop		# Copy the Scratch_Start to the Menu
# sudo chmod 777 /usr/share/applications/scratch.desktop							# Menu Shortcut Permissions.
# sudo chmod 777 /usr/share/raspi-ui-overrides/applications/scratch.desktop		# Menu Shortcut Permissions.


# If not called from Raspbian for Robots, pull in the wxpython libraries
if ! quiet_mode
then
    sudo apt-get install python-wxgtk2.8 python-wxgtk3.0 python-wxtools wx2.8-i18n python-psutil --yes 
fi

# # Make run_scratch_gui executable.
sudo chmod +x $SCRATCH_PATH/Scratch_Start.sh
# # Make scratch start example read only.
sudo chmod ugo+r $SCRATCH_PATH/new.sb	# user, group, etc are just read only
# # Make select_state, error_log, nohup.out readable and writable
sudo chmod 666 $SCRATCH_PATH/selected_state
sudo chmod 666 $SCRATCH_PATH/error_log
sudo chmod 666 $PIHOME/nohup.out

# Install Scratch Example Shortcuts for the Products
# This will create symbolic links to the various example scripts.  https://blog.bartbania.com/raspberry_pi/create-symbolic-links-in-linux/
#ln -s $PIHOME/Desktop/GrovePi/Software/Scratch/Grove_Examples/ GrovePi
#ln -s $PIHOME/Desktop/GoPiGo/Software/Scratch/Examples/ GoPiGo
#ln -s $PIHOME/Desktop/BrickPi_Scratch/Examples/ BrickPi

# Add the soft links that allows users to reach the Dexter Ind Scratch examples from within the Scratch interface

# Note: there was a weird issue with the softlinks being created 
# where they were not supposed to be.
# ensuring that there isn't a pre-existing softlink fixes this issue

# BrickPi+ link
sudo rm  /usr/share/scratch/Projects/BrickPi 2> /dev/null
sudo rm  /usr/share/scratch/Projects/BrickPi+ 2> /dev/null
sudo ln -s /home/pi/Dexter/BrickPi+/Software/BrickPi_Scratch/Examples /usr/share/scratch/Projects/BrickPi+ 2> /dev/null

# BrickPi3 link
sudo rm /usr/share/scratch/Projects/BrickPi3 2> /dev/null
sudo ln -s /home/pi/Dexter/BrickPi3/Software/Scratch/Examples /usr/share/scratch/Projects/BrickPi3 2> /dev/null

# GoPiGo link
sudo rm  /usr/share/scratch/Projects/GoPiGo 2> /dev/null
sudo ln -s /home/pi/Dexter/GoPiGo/Software/Scratch/Examples /usr/share/scratch/Projects/GoPiGo  2> /dev/null

# GoPiGo3 link
sudo rm  /usr/share/scratch/Projects/GoPiGo3 2> /dev/null
sudo ln -s /home/pi/Dexter/GoPiGo3/Software/Scratch/Examples /usr/share/scratch/Projects/GoPiGo3  2> /dev/null

# GrovePi Link
sudo rm /usr/share/scratch/Projects/GrovePi 2> /dev/null
sudo ln -s /home/pi/Dexter/GrovePi/Software/Scratch/Grove_Examples /usr/share/scratch/Projects/GrovePi 2> /dev/null

# PivotPi Link
sudo rm  /usr/share/scratch/Projects/PivotPi 2> /dev/null
sudo ln -s /home/pi/Dexter/PivotPi/Software/Scratch/Examples /usr/share/scratch/Projects/PivotPi 2> /dev/null 


# Remove Scratch Shortcuts if they're there.
[ -f $PIHOME/Desktop/BrickPi_Scratch_Start.desktop ] && sudo rm $PIHOME/Desktop/BrickPi_Scratch_Start.desktop
[ -f $PIHOME/Desktop/GoPiGo_Scratch_Start.desktop ] && sudo rm $PIHOME/Desktop/GoPiGo_Scratch_Start.desktop
[ -f $PIHOME/Desktop/scratch.desktop ] && sudo rm $PIHOME/Desktop/scratch.desktop

VERSION=$(sed 's/\..*//' /etc/debian_version)
echo "Version: $VERSION"

if [ $VERSION -eq '8' ] ; then
    # Make sure that Scratch always starts Scratch GUI
    # We'll install these parts to make sure that if a user double-clicks on a file on the desktop
    # Scratch GUI is launched, and all other programs are killed.

    #delete scratch from /usr/bin
    sudo rm /usr/bin/scratch
    # make a new scratch in /usr/bin
    sudo cp $SCRATCH_PATH/scratch_jessie /usr/bin/scratch
    # Change scratch permissions
    sudo chmod +x /usr/bin/scratch

    # set permissions
    # sudo chmod +x $PIHOME/$DEXTER/Scratch_GUI/scratch_launch
    sudo chmod +x $SCRATCH_PATH/scratch_direct

    # remove annoying dialog that says remote sensors are enabled
    echo "remoteconnectiondialog = 0" > /home/pi/.scratch.ini
elif [ $VERSION -eq '9' ] ; then
    # associate Scratch file to our program
    cp $SCRATCH_PATH/mimeapps.list $HOME/.config/
fi

popd > /dev/null

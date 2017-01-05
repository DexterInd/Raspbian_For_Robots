#! /bin/bash
# Copyright Dexter Industries, 2015.
# Install the Scratch GUI.
# Dev Notes:
# Helpful Link on Bin Paths:  http://www.cyberciti.biz/faq/how-do-i-find-the-path-to-a-command-file/

source ../upd_script/functions_library.sh

HOME=/home/pi
DEXTER=Dexter
SCRATCH=Scratch_GUI
SCRATCH_PATH=$HOME/$DEXTER/$SCRATCH

if [ ! -d $HOME/$DEXTER ] ; then
	feedback "Creating $HOME/$DEXTER"
	mkdir $HOME/$DEXTER
fi
if [ ! -d $HOME/$DEXTER/$SCRATCH ] ; then
	feedback "Creating $HOME/$DEXTER/$SCRATCH"
	mkdir $HOME/$DEXTER/$SCRATCH
fi

feedback "Installing Scratch Environment"
cp $HOME/di_update/Raspbian_For_Robots/$SCRATCH/* $SCRATCH_PATH

if [ -d $HOME/Desktop/GoBox/Scratch_GUI ] ; then
	feedback "Removing $HOME/Desktop/GoBox/Scratch_GUI"
	sudo rm -r $HOME/Desktop/GoBox/Scratch_GUI
fi

# Copy shortcut to desktop.
feedback "Installing Scratch on the desktop"
cp $SCRATCH_PATH/Scratch_Start.desktop $HOME/Desktop
# Make shortcut executable
sudo chmod +x $HOME/Desktop/Scratch_Start.desktop							# Desktop shortcut permissions.

# sudo rm /usr/share/applications/scratch.desktop															# Remove the Scratch Start button in the Menu

######
# Added these to solve the menu problem of scratch.  Then removed them.  
# These are removed for now, the call up the Scratch Gui, not the scratch start.
# sudo rm /usr/share/raspi-ui-overrides/applications/scratch.desktop										# Remove the Scratch Start button in the Menu
# sudo cp /home/pi/$DEXTER/Scratch_GUI/Scratch_Start.desktop /usr/share/applications/scratch.desktop						# Copy the Scratch_Start to the Menu
# sudo cp /home/pi/$DEXTER/Scratch_GUI/Scratch_Start.desktop /usr/share/raspi-ui-overrides/applications/scratch.desktop		# Copy the Scratch_Start to the Menu
# sudo chmod 777 /usr/share/applications/scratch.desktop							# Menu Shortcut Permissions.
# sudo chmod 777 /usr/share/raspi-ui-overrides/applications/scratch.desktop		# Menu Shortcut Permissions.



# # Make run_scratch_gui executable.
sudo chmod +x $SCRATCH_PATH/Scratch_Start.sh
# # Make scratch start example read only.
sudo chmod ugo+r $SCRATCH_PATH/new.sb	# user, group, etc are just read only
# # Make select_state, error_log, nohup.out readable and writable
sudo chmod 666 $SCRATCH_PATH/selected_state
sudo chmod 666 $SCRATCH_PATH/error_log
sudo chmod 666 $HOME/nohup.out

# Install Scratch Example Shortcuts for the Products
# This will create symbolic links to the various example scripts.  https://blog.bartbania.com/raspberry_pi/create-symbolic-links-in-linux/
#ln -s $HOME/Desktop/GrovePi/Software/Scratch/Grove_Examples/ GrovePi
#ln -s $HOME/Desktop/GoPiGo/Software/Scratch/Examples/ GoPiGo
#ln -s $HOME/Desktop/BrickPi_Scratch/Examples/ BrickPi

# Add the soft links that allows users to reach the Dexter Ind Scratch examples from within the Scratch interface

# BrickPi link
[ ! -d /usr/share/scratch/Projects/BrickPi ]  && sudo ln -s $HOME/Dexter/BrickPi_Scratch/Examples /usr/share/scratch/Projects/BrickPi

# GoPiGo link
[ ! -d /usr/share/scratch/Projects/GoPiGo ]  && sudo ln -s $HOME/Dexter/GoPiGo/Software/Scratch/Examples /usr/share/scratch/Projects/GoPiGo

# GrovePi Link
[ ! -d /usr/share/scratch/Projects/GrovePi ]  && sudo ln -s $HOME/Dexter/GrovePi/Software/Scratch/Grove_Examples /usr/share/scratch/Projects/GrovePi

# PivotPi Link
[ ! -d /usr/share/scratch/Projects/PivotPi ]  && sudo ln -s $HOME/Dexter/PivotPi/Software/Scratch/Examples /usr/share/scratch/Projects/PivotPi


# Remove Scratch Shortcuts if they're there.
[ -f $HOME/Desktop/BrickPi_Scratch_Start.desktop ] && sudo rm $HOME/Desktop/BrickPi_Scratch_Start.desktop
[ -f $HOME/Desktop/GoPiGo_Scratch_Start.desktop ] && sudo rm $HOME/Desktop/GoPiGo_Scratch_Start.desktop
[ -f $HOME/Desktop/scratch.desktop ] && sudo rm $HOME/Desktop/scratch.desktop

# Make sure that Scratch always starts Scratch GUI
# We'll install these parts to make sure that if a user double-clicks on a file on the desktop
# Scratch GUI is launched, and all other programs are killed.

#delete scratch from /usr/bin
sudo rm /usr/bin/scratch
# make a new scratch in /usr/bin
sudo cp $SCRATCH_PATH/scratch /usr/bin
# Change scratch permissions
sudo chmod +x /usr/bin/scratch

# set permissions
# sudo chmod +x $HOME/$DEXTER/Scratch_GUI/scratch_launch
sudo chmod +x $SCRATCH_PATH/scratch_direct

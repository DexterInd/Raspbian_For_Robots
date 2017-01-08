#! /bin/bash

# Can't use $HOME here as this is being run as sudo and $home defaults to root
PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots

# This script updates the the code repos on Raspbian for Robots.
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

set_quiet_mode

########################################################################
## Staging Code.
## Change this code to operate out of a particular branch of code.

## Uncomment this and add a branch name to work from a particular branch.
BRANCH=update201612

# Function checks out branch if BRANCH is defined.
change_branch() {
    if [ -z ${BRANCH+x} ]; then 
        echo "Working from main branch."; 
    else 
        echo "Working from $BRANCH branch";
        # sudo git checkout -b $BRANCH
        # the -b creates a branch if it doesn't exist
        # this leads to a fatal error msg being displayed to the user
        # is there any case where we can to create the branch here???
        # https://github.com/tldr-pages/tldr/blob/master/pages/common/git-checkout.md
        sudo git checkout $BRANCH
    fi
}

########################################################################
## IMPORT FUNCTIONS LIBRARY
## Note if you're doing any testing: to make this work you need to chmod +x it, and then run the file it's called from as ./update_all.sh 
## Importing the source will not work if you run "sudo sh update_all.sh"
source /home/pi/di_update/Raspbian_For_Robots/upd_script/functions_library.sh

robots_2_update="/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/robots_2_update"
if [ -f $robots_2_update ]  # if the file exists, read it and adjust according to its content
then
    gopigo_update=0
    brickpi_update=0
    grovepi_update=0
    arduberry_update=0
    pivotpi=0
    while read -r line 
        do
        echo "Text read from file: $line"
        if [ "$line" == "GoPiGo" ] ; then
           gopigo_update=1
        elif [ "$line" == "BrickPi" ] ; then
           brickpi_update=1
        elif [ "$line" == "GrovePi" ] ; then
           grovepi_update=1
        elif [ "$line" == "Arduberry" ] ; then
           arduberry_update=1
        elif [ "$line" == "PivotPi" ] ; then
           pivotpi_update=1
        fi
    done < $robots_2_update 
else # if the file doesn't exist, update everything
    gopigo_update=1
    brickpi_update=1
    grovepi_update=1
    arduberry_update=1
    pivotpi_update=1
fi

###############################################
# GOPIGO
###############################################

if [ $gopigo_update == 1 ] ; then
    # GoPiGo Update
    feedback "--> Start GoPiGo Update."
    feedback "##############################"
    # Changed file Location to ~/Dexter
    delete_folder /home/pi/Desktop/GoPiGo       # Delete the old location

    # Check for a GoPiGo directory.  If it doesn't exist, create it.
    GOPIGO_DIR=$DEXTER_PATH/GoPiGo
    if folder_exists $GOPIGO_DIR; then
        echo "GoPiGo Directory Exists"
        cd $DEXTER_PATH/GoPiGo  # Go to directory
        sudo git fetch origin       # Hard reset the git files
        sudo git reset --hard  
        sudo git merge origin/master
    else
        cd $DEXTER_PATH
        git clone https://github.com/DexterInd/GoPiGo
        cd $DEXTER_PATH/GoPiGo
        change_branch   # change to a branch we're working on.
    fi

    cd $DEXTER_PATH/GoPiGo/Setup
    feedback "--> UPDATING LIBRARIES"
    feedback "------------------"
    sudo bash ./install.sh


    feedback "--> Installing Line Follower Calibration"
    # Install GoPiGo Line Follower Calibration
    delete_file /home/pi/Desktop/line_follow.desktop
    sudo cp /home/pi/Dexter/GoPiGo/Software/Python/line_follower/line_follow.desktop /home/pi/Desktop/
    sudo chmod +x /home/pi/Desktop/line_follow.desktop
    sudo chmod +x /home/pi/Dexter/GoPiGo/Software/Python/line_follower/line_sensor_gui.py

    # feedback "--> Install Scratch dependency ScratchPy."
    # cd /home/pi/Dexter/GoPiGo/Software/Scratch
    # sudo git clone https://github.com/DexterInd/scratchpy.git
    # cd scratchpy
    # sudo make install

    #GoPiGo Scratch Permissions
    #echo "--> Install Scratch Shortcuts and Permissions."
    #sudo rm /home/pi/Desktop/GoPiGo_Scratch_Start.desktop                      # Delete old icons off desktop
    #sudo cp /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGo_Scratch_Start.desktop /home/pi/Desktop  # Move icons to desktop
    sudo chmod +x /home/pi/Dexter/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGoScratch_debug.sh                 # Change script permissions
    sudo chmod +x /home/pi/Dexter/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGo_Scratch_Start.sh                    # Change script permissions
    sudo chmod -R 777 /usr/share/scratch/Projects/
else
    echo "--> GoPiGo **NOT** Updated."
    echo "----------"
fi  # end conditional statement on GOPIGO UPDATE

###############################################
# BRICKPI
###############################################

if [ $brickpi_update == 1 ] ; then

    # BrickPi3 Update
    feedback "--> Start BrickPi3 Update."
    feedback "##############################"
    # Check for a BrickPi directory under "Dexter" folder.  If it doesn't exist, create it.
    BRICKPI3_DIR=$DEXTER_PATH/BrickPi3
    if folder_exists "$BRICKPI3_DIR" ; then
        echo "BrickPi3 Directory Exists"
        cd $DEXTER_PATH/BrickPi3    # Go to directory
        sudo git fetch origin       # Hard reset the git files
        sudo git reset --hard  
        sudo git merge origin/master
        change_branch
    else
        cd $DEXTER_PATH
        git clone https://github.com/DexterInd/BrickPi3
        cd BrickPi3
        change_branch   # change to a branch we're working on, if we've defined the branch above.
    fi
#   sudo chmod +x /home/pi/Dexter/BrickPi3/Install/install.sh
    sudo bash /home/pi/Dexter/BrickPi3/Install/install.sh


    # BrickPi+ Update
    # BrickPi+ is the Master Directory, and the BrickPi_X directories will go in under it.
    feedback "--> Start BrickPi Update."
    feedback "##############################"
    delete_folder /home/pi/Desktop/BrickPi     # Delete the old location
    # Check for a BrickPi directory under "Dexter" folder.  If it doesn't exist, create it.
    BRICKPI_DIR=$DEXTER_PATH/BrickPi+
    if [ -d "$BRICKPI_DIR" ]; then
        echo "BrickPi Directory Exists"
        cd $DEXTER_PATH/BrickPi+/BrickPi # Go to directory
        sudo git fetch origin       # Hard reset the git files
        sudo git reset --hard  
        sudo git merge origin/master
        change_branch       
    else
        sudo mkdir $DEXTER_PATH/BrickPi+
        cd $DEXTER_PATH/BrickPi+
        git clone https://github.com/DexterInd/BrickPi .
        cd $DEXTER_PATH/BrickPi+/BrickPi
        change_branch   # change to a branch we're working on, if we've defined the branch above.
    fi

    # BrickPi_Python Update
    echo "--> Start BrickPi_Python Update."
    echo "----------"
    sudo rm -r /home/pi/Desktop/BrickPi_Python      # Delete the old location
    
    # Moved this to the update_all --> sudo apt-get install python-setuptools
    # Remove Python Packages
    cd $DEXTER_PATH/BrickPi+/BrickPi/Software/BrickPi_Python/
    sudo python $DEXTER_PATH/BrickPi+/BrickPi/Software/BrickPi_Python/setup.py install

    # BrickPi_Scratch Update
    echo "--> Start BrickPi_Scratch Update."
    echo "----------"
    sudo rm -r /home/pi/Desktop/BrickPi_Scratch     # Delete the old location

    cd $DEXTER_PATH/BrickPi+/BrickPi/Software/BrickPi_Scratch
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
    sudo rm -r /home/pi/Desktop/BrickPi_C       # Delete the old location

else
    echo "--> BrickPi **NOT** Updated."
    echo "----------"
fi # end conditional statement on BRICKPI UPDATE

if [ $arduberry_update == 1 ] ; then

    # Arduberry Update
    feedback "--> Start Arduberry Update."
    feedback "----------"

    sudo rm -r /home/pi/Desktop/ArduBerry       # Delete the old location

    # Check for a Arduberry directory under "Dexter" folder.  If it doesn't exist, create it.
    ARDUBERRY_DIR=$DEXTER_PATH/ArduBerry
    if [ -d "$ARDUBERRY_DIR" ]; then
        echo "Arduberry Directory Exists"
        cd $ARDUBERRY_DIR   # Go to directory
        sudo git fetch origin       # Hard reset the git files
        sudo git reset --hard  
        sudo git merge origin/master
    else
        cd $DEXTER_PATH
        git clone https://github.com/DexterInd/ArduBerry
    fi

    sudo chmod +x $ARDUBERRY_DIR/script/install.sh
    sudo bash $ARDUBERRY_DIR/script/install.sh
else
    echo "--> Arduberry **NOT** Updated."
    echo "----------"
fi 
# end conditional statement on ARDUBERRY UPDATE

###############################################
# GROVEPI
###############################################

if [ $grovepi_update == 1 ] ; then

    # GrovePi Update
    feedback "--> Start GrovePi Update."
    feedback "----------"
    
    sudo rm -r /home/pi/Desktop/GrovePi     # Delete the old location

    # Check for a GrovePi directory under "Dexter" folder.  If it doesn't exist, create it.
    GROVEPI_DIR=$DEXTER_PATH/GrovePi
    if [ -d "$GROVEPI_DIR" ]; then
        echo "GrovePi Directory Exists"
        cd $GROVEPI_DIR             # Go to directory
        sudo git fetch origin       # Hard reset the git files
        sudo git reset --hard  
        sudo git merge origin/master
    else
        cd /home/pi/Dexter/
        git clone https://github.com/DexterInd/GrovePi
    fi
    change_branch
    
    feedback "--> Start GrovePi update install."
    feedback "----------"
    cd /home/pi/di_update/Raspbian_For_Robots/      # Going to change the Raspbian for Robots git branch.
    change_branch                                   # Change branch to the one we're working on
    cd /home/pi/di_update/Raspbian_For_Robots/upd_script
    sudo chmod +x update_GrovePi.sh
    sudo bash /home/pi/di_update/Raspbian_For_Robots/upd_script/update_GrovePi.sh

    # GrovePi Scratch Setup
    # sudo rm /home/pi/Desktop/GrovePi_Scratch_Start.desktop                    # Delete old icons off desktop
    # sudo cp /home/pi/Desktop/GrovePi/Software/Scratch/GrovePi_Scratch_Scripts/GrovePi_Scratch_Start.desktop /home/pi/Desktop  # Move icons to desktop
    sudo chmod +x /home/pi/Dexter/GrovePi/Software/Scratch/GrovePi_Scratch_Scripts/GrovePiScratch_debug.sh                      # Change script permissions
    sudo chmod +x /home/pi/Dexter/GrovePi/Software/Scratch/GrovePi_Scratch_Scripts/GrovePi_Scratch_Start.sh                 # Change script permissions
    
else
    echo "--> GrovePi **NOT** Updated."
    echo "----------"
fi # end conditional statement on GrovePi update

###############################################
# PIVOTPI
###############################################


if [ $pivotpi_update == 1 ] ; then
    
    pushd /home/pi

    # if Dexter folder doesn't exist, then create it
    if [ ! -d "Dexter" ]; then
        mkdir "Dexter"
    fi
    cd /home/pi/Dexter
    
    # if pivotpi folder doesn't exit then clone repo
    if [ ! -d "PivotPi" ]; then
        sudo git clone https://github.com/DexterInd/PivotPi.git
    fi

    cd $DEXTER_PATH/PivotPi  
    sudo git fetch origin   
    sudo git reset --hard  
    sudo git merge origin/master
    cd $DEXTER_PATH/PivotPi/Install

    sudo bash $DEXTER_PATH/PivotPi/Install/install.sh
    
    popd
else
    echo "--> PivotPi **NOT** Updated"
    echo "----------"
fi

# Install DexterEd Software
feedback "--> Install DexterEd Software"
sudo rm -r /home/pi/Desktop/DexterEd

cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/DexterEd.git

# Install GoBox Software
feedback "--> Install GoBox Software"
sudo rm -r /home/pi/Desktop/GoBox
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/GoBox.git
# sudo chmod +x /home/pi/Desktop/GoBox/Scratch_GUI/install_scratch_start.sh
# sudo bash /home/pi/Desktop/GoBox/Scratch_GUI/install_scratch_start.sh
delete_folder /home/pi/Desktop/GoBox/Scratch_GUI

# sudo chmod +x /home/pi/Desktop/GoBox/LIRC_GUI/install_ir_start.sh
# sudo bash /home/pi/Desktop/GoBox/LIRC_GUI/install_ir_start.sh
# sudo rm -r /home/pi/Desktop/build
# sudo rm -r /home/pi/Desktop/dist
# sudo rm -r /home/pi/Desktop/ir_receiver_check.egg-info
delete_folder /home/pi/Desktop/GoBox/LIRC_GUI

cp /home/pi/di_update/Raspbian_For_Robots/advanced_communication_options/advanced_comms_options.desktop /home/pi/Desktop

# in Jessie, add a warning before user can reach the Raspberry Pi Configuration Menu Item
VERSION=$(sed 's/\..*//' /etc/debian_version)
if [ $VERSION -eq '8' ]; then
  sudo cp /home/pi/di_update/Raspbian_For_Robots/rpi_config_menu_gui/rc_gui.desktop /usr/share/applications/rc_gui.desktop
fi

# Install GoBox Troubleshooting Software
sudo rm /home/pi/Desktop/Troubleshooting_Start.desktop
sudo chmod +x /home/pi/Desktop/GoBox/Troubleshooting_GUI/install_troubleshooting_start.sh
sudo bash /home/pi/Desktop/GoBox/Troubleshooting_GUI/install_troubleshooting_start.sh

#########################################
# Install All Python Scripts

#########################################
if [ $brickpi_update=1 ] ; then
    # BrickPi Python Installation
    cd /home/pi/Dexter/BrickPi+/BrickPi/Software/BrickPi_Python/
    sudo python setup.py install --record files.txt

    # This will cause all the installed files to be printed to that directory.
    # Remove the files.txt

    sudo cat files.txt | xargs sudo rm -rf
    sudo rm files.txt
    sudo python setup.py install
fi # end second brickpi conditional test

##########################################
#GoPiGo Python Installation
if [ $gopigo_update=1 ] ; then
    echo "Installing GoPiGo Libraries from Fetch"
    cd /home/pi/Dexter/GoPiGo/Software/Python/
    sudo python setup.py install --record files.txt
    sudo cat files.txt | xargs sudo rm -rf
    sudo rm files.txt
    sudo python setup.py install
fi # end second gopigo conditional test


##########################################
# GoPiGo Line Follower Installation
# TBA

#########################################
#  GrovePi
if [ $grovepi_update=1 ] ; then
    cd /home/pi/Dexter/GrovePi/Software/Python/
    sudo python setup.py install --record files.txt
    sudo cat files.txt | xargs sudo rm -rf
    sudo rm files.txt
    sudo python setup.py install
fi

echo "--> Done updating Dexter Industries Github repos!"

unset_quiet_mode

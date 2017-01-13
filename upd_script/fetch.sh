#! /bin/bash

# Can't use $HOME here as this is being run as sudo and $home defaults to root
PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots

# This script updates the the code repos on Raspbian for Robots.
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

set_quiet_mode

set_softlink_for(){
    # if the detected_robot file exists
    # then we will create a softlink onto the desktop
    # for the detected robots. Non detected robots will not get a softlink
    # if the file doesn't exist,
    # then set all softlinks (assume a simulator mode)
    if file_exists $PIHOME/$DEXTER/detected_robot.txt
    then
        if find_in_file "$1" $PIHOME/$DEXTER/detected_robot.txt
        then
            echo "found in file"
            sudo ln -s -f $DEXTER_PATH/$1 /home/pi/Desktop/$1
        else
            delete_folder "$1"
        fi   
    else
        echo "file doesn't exist"
        sudo ln -s -f $DEXTER_PATH/$1 /home/pi/Desktop/$1
    fi
}

set_all_softlinks(){
    sudo python $PIHOME/$DEXTER/lib/$DEXTER/auto_detect_robot.py
    set_softlink_for "GoPiGo"
    set_softlink_for "GrovePi"
    set_softlink_for "BrickPi+"
    set_softlink_for "BrickPi3"
    set_softlink_for "PivotPi"

}

########################################################################
## Staging Code.
## Change this code to operate out of a particular branch of code.
## Uncomment this and add a branch name to work from a particular branch.
BRANCH=update201612

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
    source $RASPBIAN/upd_script/fetch_gopigo.sh
else
    feedback "--> GoPiGo **NOT** Updated."
    feedback "---------------------------"
fi  # end conditional statement on GOPIGO UPDATE

###############################################
# BRICKPI
###############################################

if [ $brickpi_update == 1 ] ; then

    # BrickPi3 Update
    feedback "--> Start BrickPi3 Update."
    feedback "##############################"
    source $RASPBIAN/upd_script/fetch_brickpi3.sh
#   sudo chmod +x /home/pi/Dexter/BrickPi3/Install/install.sh

    feedback "--> Start BrickPi+ Update."
    feedback "##############################"
    source $RASPBIAN/upd_script/fetch_brickpi+.sh

else
    feedback "--> BrickPi **NOT** Updated."
    feedback "----------------------------"
fi # end conditional statement on BRICKPI UPDATE

###############################################
# ARDUBERRY
###############################################
if [ $arduberry_update == 1 ] ; then

    # Arduberry Update
    feedback "--> Start Arduberry Update."
    feedback "---------------------------"

    source $RASPBIAN/upd_script/fetch_arduberry.sh
else
    feedback "--> Arduberry **NOT** Updated."
    feedback "------------------------------"
fi 
# end conditional statement on ARDUBERRY UPDATE

###############################################
# GROVEPI
###############################################

if [ $grovepi_update == 1 ] ; then

    # GrovePi Update
    feedback "--> Start GrovePi Update."
    feedback "-------------------------"
    source $RASPBIAN/upd_script/fetch_grovepi.sh
    
else
    feedback "--> GrovePi **NOT** Updated."
    feedback "----------------------------"
fi # end conditional statement on GrovePi update


###############################################
# PIVOTPI
###############################################
if [ $pivotpi_update == 1 ] ; then
    feedback "--> Start PivotPi Update."
    feedback "-------------------------"
    
    pushd /home/pi > /dev/null

    # if Dexter folder doesn't exist, then create it
    create_folder $DEXTER
    cd $DEXTER_PATH
    source $RASPBIAN/upd_script/fetch_pivotpi.sh
        
    popd > /dev/null
else
    echo "--> PivotPi **NOT** Updated"
    echo "---------------------------"
fi

set_all_softlinks

# Install DexterEd Software
feedback "--> Install DexterEd Software"
feedback "-----------------------------"
delete_folder /home/pi/Desktop/DexterEd

cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/DexterEd.git

# Install GoBox Software
feedback "--> Install GoBox"
feedback "-----------------"
delete_folder /home/pi/Desktop/GoBox
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/GoBox.git

delete_folder /home/pi/Desktop/GoBox/Scratch_GUI
delete_folder /home/pi/Desktop/GoBox/LIRC_GUI

cp /home/pi/di_update/Raspbian_For_Robots/advanced_communication_options/advanced_comms_options.desktop /home/pi/Desktop

# in Jessie, add a warning before user can reach the Raspberry Pi Configuration Menu Item
VERSION=$(sed 's/\..*//' /etc/debian_version)
if [ $VERSION -eq '8' ]; then
  sudo cp /home/pi/di_update/Raspbian_For_Robots/rpi_config_menu_gui/rc_gui.desktop /usr/share/applications/rc_gui.desktop
fi

# Install GoBox Troubleshooting Software
delete_file /home/pi/Desktop/Troubleshooting_Start.desktop
sudo chmod +x /home/pi/Desktop/GoBox/Troubleshooting_GUI/install_troubleshooting_start.sh
sudo bash /home/pi/Desktop/GoBox/Troubleshooting_GUI/install_troubleshooting_start.sh



#########################################
# Install All Python Scripts

#########################################
if [ $brickpi_update=1 ] ; then
    # BrickPi Python Installation
    cd /home/pi/Dexter/BrickPi+/Software/BrickPi_Python/
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

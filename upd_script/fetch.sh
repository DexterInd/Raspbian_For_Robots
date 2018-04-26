#! /bin/bash
sudo sh -c "curl -kL dexterindustries.com/update_tools | bash"

# Can't use $HOME here as this is being run as sudo and $home defaults to root
PIHOME=/home/pi
DEXTER=Dexter
DESKTOP=Desktop
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots

# This script updates the the code repos on Raspbian for Robots.
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh
VERSION=$(sed 's/\..*//' /etc/debian_version)
set_quiet_mode

set_softlink_for(){
    # if the detected_robot file exists
    # then we will create a softlink onto the desktop
    # for the detected robots. 
    # Non detected robots will not get a softlink.
    # If the file doesn't exist,
    # then set all softlinks (assume a simulator mode)
    # start by deleting the folder/softlink on the desktop

    delete_folder "$PIHOME/$DESKTOP/$1"
    if file_exists $PIHOME/$DEXTER/detected_robot.txt
    then
        if find_in_file_strict "$1" $PIHOME/$DEXTER/detected_robot.txt
        then
            sudo ln -s -f $DEXTER_PATH/$1 /home/pi/Desktop/$1
        fi   
        if find_in_file_strict "None" $PIHOME/$DEXTER/detected_robot.txt
        then
            sudo ln -s -f $DEXTER_PATH/$1 /home/pi/Desktop/$1
        fi   
    else
        sudo ln -s -f $DEXTER_PATH/$1 /home/pi/Desktop/$1
    fi
}

set_all_softlinks(){
    # auto_detect_robot now in script_tools
    sudo python /home/pi/Dexter/lib/Dexter/script_tools/auto_detect_robot.py
    set_softlink_for "GoPiGo3"
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
# BRANCH=update201612

########################################################################
## IMPORT FUNCTIONS LIBRARY
## Note if you're doing any testing: to make this work you need to chmod +x it, and then run the file it's called from as ./update_all.sh 
## Importing the source will not work if you run "sudo sh update_all.sh"
# source /home/pi/Dexter/lib/Dexter/script_tools/functions_library.sh

staging(){
    gopigo_update=1
    brickpi_update=1
    grovepi_update=1
    arduberry_update=1
    pivotpi_update=1
    sensors_update=1
}

###############################################
# GOPIGO
###############################################

update_gopigo() {
    if [ $gopigo_update == 1 ] ; then
        # GoPiGo3 Update
        feedback "--> Start GoPiGo3 Update."
        feedback "##############################"
        curl -kL dexterindustries.com/update_gopigo3 | sudo bash
        
        # GoPiGo Update
        feedback "--> Start GoPiGo Update."
        feedback "##############################"
        curl -kL dexterindustries.com/update_gopigo | sudo bash
    else
        feedback "--> GoPiGo **NOT** Updated."
        feedback "---------------------------"
    fi  # end conditional statement on GOPIGO UPDATE
}

###############################################
# BRICKPI
###############################################

update_brickpi() {
    if [ $brickpi_update == 1 ] ; then

        # BrickPi3 Update
        feedback "--> Start BrickPi3 Update."
        feedback "##############################"
        curl -kL dexterindustries.com/update_brickpi3 | sudo bash
    #   sudo chmod +x /home/pi/Dexter/BrickPi3/Install/install.sh

        # Install BrickPi+ on Jessie, but not in future versions
        if [ $VERSION -eq '8' ]; then
            feedback "--> Start BrickPi+ Update."
            feedback "##############################"
            curl -kL dexterindustries.com/update_brickpi_plus | sudo bash
        fi

    else
        feedback "--> BrickPi **NOT** Updated."
        feedback "----------------------------"
    fi # end conditional statement on BRICKPI UPDATE
}

###############################################
# ARDUBERRY
###############################################

update_arduberry ()
{
    # Load up arduberry only on Jessie, drop it from Stretch onwards
    if [ $VERSION -eq '8' ]; then
        if [ $arduberry_update == 1 ] ; then

            # Arduberry Update
            feedback "--> Start Arduberry Update."
            feedback "---------------------------"

            curl -kL dexterindustries.com/update_arduberry | sudo bash
        else
            feedback "--> Arduberry **NOT** Updated."
            feedback "------------------------------"
        fi 
        # end conditional statement on ARDUBERRY UPDATE
    fi
}

###############################################
# GROVEPI
###############################################

update_grovepi() {

    if [ $grovepi_update == 1 ] ; then

        # GrovePi Update
        feedback "--> Start GrovePi Update."
        feedback "-------------------------"
        curl -kL dexterindustries.com/update_grovepi | sudo bash
    else
        feedback "--> GrovePi **NOT** Updated."
        feedback "----------------------------"
    fi # end conditional statement on GrovePi update
}


###############################################
# PIVOTPI
###############################################

update_pivotpi() {
        
    if [ $pivotpi_update == 1 ] ; then
        feedback "--> Start PivotPi Update."
        feedback "-------------------------"
        
        pushd /home/pi > /dev/null

        # if Dexter folder doesn't exist, then create it
        create_folder $DEXTER
        cd $DEXTER_PATH
        curl -kL dexterindustries.com/update_pivotpi | sudo bash
            
        popd > /dev/null
    else
        echo "--> PivotPi **NOT** Updated"
        echo "---------------------------"
    fi
}

###############################################
# SENSORS
###############################################
update_sensors() {
    

if [ $sensors_update == 1 ] ; then
    feedback "--> Start DI Sensors Update."
    feedback "-------------------------"
    
    pushd /home/pi > /dev/null

    # if Dexter folder doesn't exist, then create it
    create_folder $DEXTER
    cd $DEXTER_PATH
    curl -kL dexterindustries.com/update_sensors | sudo bash
        
    popd > /dev/null
else
    echo "--> Sensors **NOT** Updated"
    echo "---------------------------"
fi
}

###############################################
# DexterEd
###############################################
install_dextered()
# this deletes the dextered folder
{
    # Install DexterEd Software
    feedback "--> Install DexterEd Software"
    feedback "-----------------------------"
    delete_folder /home/pi/Desktop/DexterEd

    pushd /home/pi/Desktop > /dev/null
    # sudo git clone https://github.com/DexterInd/DexterEd.git
    popd > /dev/null
}

###############################################
# GoBox
###############################################
install_gobox()
# this now deletes gobox, no question asked
{
    if [ $VERSION -eq '8' ]; then
        # Install GoBox Software
        feedback "--> Install GoBox"
        feedback "-----------------"
        delete_folder /home/pi/Desktop/GoBox
        pushd /home/pi/Desktop > /dev/null
        # sudo git clone https://github.com/DexterInd/GoBox.git

        delete_folder /home/pi/Desktop/GoBox/Scratch_GUI
        delete_folder /home/pi/Desktop/GoBox/LIRC_GUI
        popd > /dev/null
    fi
}

advanced_comms(){
  cp /home/pi/di_update/Raspbian_For_Robots/advanced_communication_options/advanced_comms_options.desktop /home/pi/Desktop  
}

dead_wood() {
    
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
}

###############################################
#
# MAIN
#
###############################################
VERSION=$(sed 's/\..*//' /etc/debian_version)
staging
update_gopigo
update_brickpi
update_grovepi
update_pivotpi
update_sensors
# arduberry no longer supported.
# update_arduberry    
set_all_softlinks

install_dextered
install_gobox
advanced_comms


# in Jessie, add a warning before user can reach the Raspberry Pi Configuration Menu Item
VERSION=$(sed 's/\..*//' /etc/debian_version)
if [ $VERSION -eq '8' ]; then
  sudo cp /home/pi/di_update/Raspbian_For_Robots/rpi_config_menu_gui/rc_gui.desktop /usr/share/applications/rc_gui.desktop
fi

# Install Troubleshooting Software
delete_file /home/pi/Desktop/Troubleshooting_Start.desktop
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/install_troubleshooting_start.sh
sudo bash /home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/install_troubleshooting_start.sh

# dead_wood

echo "--> Done updating Dexter Industries Github repos!"

unset_quiet_mode

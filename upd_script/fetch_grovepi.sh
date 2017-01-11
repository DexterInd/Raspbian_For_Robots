# This script updates the the code repos on Raspbian for Robots.

# definitions needed for standalone call
PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots

# needs to be sourced from here when we call this as a standalone
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

delete_folder /home/pi/Desktop/GrovePi     # Delete the old location

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
change_branch $BRANCH
sudo ln -s -f $DEXTER_PATH/GrovePi /home/pi/Desktop/GrovePi

feedback "--> Start GrovePi update install."
feedback "----------"
cd /home/pi/di_update/Raspbian_For_Robots/upd_script
sudo chmod +x update_GrovePi.sh
sudo bash /home/pi/di_update/Raspbian_For_Robots/upd_script/update_GrovePi.sh

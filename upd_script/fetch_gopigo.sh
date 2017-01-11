PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots

# needs to be sourced from here when we call this as a standalone
source $PIHOME/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

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
    change_branch  $BRANCH # change to a branch we're working on.
fi
sudo ln -s -f $DEXTER_PATH/GoPiGo /home/pi/Desktop/GoPiGo

cd $DEXTER_PATH/GoPiGo/Setup
feedback "--> UPDATING LIBRARIES"
feedback "------------------"
sudo bash ./install.sh
PIHOME=/home/pi
DIUPDATE=di_update
RASPBIAN=Raspbian_For_Robots
RASPBIAN_PATH=$PIHOME/$DIUPDATE/$RASPBIAN

DESKTOP=Desktop
DESKTOP_PATH=$PIHOME/$DESKTOP

DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
DEXTER_LIB=lib
DEXTER_LIB_PATH=$DEXTER_PATH/$DEXTER_LIB
DEXTER_SCRIPT_TOOLS=$DEXTER/script_tools
DEXTER_SCRIPT_TOOLS_PATH=$DEXTER_LIB_PATH/$DEXTER_SCRIPT_TOOLS
source $DEXTER_SCRIPT_TOOLS_PATH/functions_library.sh

VERSION=$(sed 's/\..*//' /etc/debian_version)


echo "START DESKTOP SHORTCUT UPDATE."
echo "=============================="
# Update the Desktop Shortcut for Software Update
# sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/desktop_shortcut_update.sh
# sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/desktop_shortcut_update_start.sh
delete_file $DESKTOP_PATH/desktop_shortcut_update.desktop
cp $RASPBIAN_PATH/desktop_shortcut_update.desktop /home/pi/Desktop
chmod +x $DESKTOP_PATH/desktop_shortcut_update.desktop

delete_file $DESKTOP_PATH/shutdown.desktop
cp $RASPBIAN_PATH/shutdown.desktop /home/pi/Desktop
chmod +x $DESKTOP_PATH/shutdown.desktop

delete_file $DESKTOP_PATH/dexterindustries.desktop

if [ $VERSION -eq '10' ]
then
    delete_file $DESKTOP_PATH/wpa_gui.desktop
fi

if [ $VERSION -eq '9' ]
then
    delete_file $DESKTOP_PATH/wpa_gui.desktop
fi

if [ $VERSION -eq '8' ]
then
    # These 3 deletes are probably remnants of Wheezy
    delete_file $DESKTOP_PATH/idle3.desktop
    delete_file $DESKTOP_PATH/idle.desktop
    delete_file $DESKTOP_PATH/gksu.desktop

    # Rename the wifi control.  Change the icon.
    delete_file $DESKTOP_PATH/wpa_gui.desktop
    cp $RASPBIAN_PATH/desktop/wpa_gui.desktop /home/pi/Desktop
    chmod +x $DESKTOP_PATH/wpa_gui.desktop
fi

# Update the Backup
delete_file $DESKTOP_PATH/backup.desktop
cp $RASPBIAN_PATH/backup/backup.desktop /home/pi/Desktop
chmod +x $DESKTOP_PATH/backup.desktop

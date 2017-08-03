PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots
curl --silent https://raw.githubusercontent.com/DexterInd/script_tools/master/install_script_tools.sh | bash

# needs to be sourced from here when we call this as a standalone
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

###############################################
## Install DI_Sensors
###############################################
SENSOR_DIR=$DEXTER_PATH/DI_Sensors
if folder_exists "$SENSOR_DIR" ; then
    echo "DI_Sensors Directory Exists"
    pushd $DEXTER_PATH/DI_Sensors  # Go to directory
    sudo git fetch origin       # Hard reset the git files
    sudo git reset --hard
    sudo git merge origin/master
    popd

else
    pushd $DEXTER_PATH
    git clone https://github.com/DexterInd/DI_Sensors
    popd

fi

pushd $SENSOR_DIR/Python
sudo python setup.py install
sudo python3 setup.py install
popd

pushd $SENSOR_DIR/Python/di_sensors/DHT_Sensor
sudo python setup.py install
sudo python3 setup.py install
popd

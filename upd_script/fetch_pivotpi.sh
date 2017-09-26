PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
RASPBIAN=$PIHOME/di_update/Raspbian_For_Robots
curl --silent https://raw.githubusercontent.com/DexterInd/script_tools/master/install_script_tools.sh | bash

# needs to be sourced from here when we call this as a standalone
source /home/pi/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

pushd $DEXTER_PATH > /dev/null

# if pivotpi folder doesn't exit then clone repo
if [ ! -d "PivotPi" ]; then
    sudo git clone https://github.com/DexterInd/PivotPi.git
else
    cd $DEXTER_PATH/PivotPi
    sudo git fetch origin
    sudo git reset --hard
    sudo git merge origin/master
fi
#change_branch $BRANCH

sudo bash $DEXTER_PATH/PivotPi/Install/install.sh

popd > /dev/null

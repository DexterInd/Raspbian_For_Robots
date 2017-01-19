if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 
	exit 1
fi

if [[ -f /home/pi/quiet_mode ]];  then
	quiet_mode=1
else
	quiet_mode=0
fi

if [[ "$quiet_mode" -eq "0" ]]
then
	echo "  _____            _                                ";
	echo " |  __ \          | |                               ";
	echo " | |  | | _____  _| |_ ___ _ __                     ";
	echo " | |  | |/ _ \ \/ / __/ _ \ '__|                    ";
	echo " | |__| |  __/>  <| ||  __/ |                       ";
	echo " |_____/ \___/_/\_\\__\___|_| _        _            ";
	echo " |_   _|         | |         | |      (_)           ";
	echo "   | |  _ __   __| |_   _ ___| |_ _ __ _  ___  ___  ";
	echo "   | | | '_ \ / _\ | | | / __| __| '__| |/ _ \/ __|";
	echo "  _| |_| | | | (_| | |_| \__ \ |_| |  | |  __/\__ \ ";
	echo " |_____|_| |_|\__,_|\__,_|___/\__|_|  |_|\___||___/ ";
	echo "                                                    ";
	echo "                                                    ";
	echo " "
fi

PIHOME="/home/pi"
DEXTER="Dexter"
if [ ! -d $PIHOME/$DEXTER ] ; then
	echo "Creating $PIHOME/$DEXTER"
	mkdir $PIHOME/$DEXTER
fi
if [ ! -d $PIHOME/$DEXTER/lib ] ; then
	echo "Creating $PIHOME/$DEXTER/lib"
	mkdir $PIHOME/$DEXTER/lib
fi
if [ -d $PIHOME/$DEXTER/lib ] ; then
	echo "Copying libraries into $PIHOME/$DEXTER/lib"
	sudo cp -r $PIHOME/di_update/Raspbian_For_Robots/lib/* $PIHOME/$DEXTER/lib
fi

pushd $PIHOME/$DEXTER/lib

cd Adafruit
sudo python setup.py install
sudo python3 setup.py install

popd


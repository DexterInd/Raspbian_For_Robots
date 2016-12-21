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

HOME="/home/pi"
DEXTER="Dexter"
if [ ! -d $HOME/$DEXTER ] ; then
	echo "Creating $HOME/$DEXTER"
	mkdir $HOME/$DEXTER
fi
if [ ! -d $HOME/$DEXTER/lib ] ; then
	echo "Creating $HOME/$DEXTER/lib"
	mkdir $HOME/$DEXTER/lib
fi
if [ -d $HOME/$DEXTER/lib ] ; then
	"Copying libraries into $HOME/$DEXTER/lib"
	sudo cp -r $HOME/di_update/Raspbian_For_Robots/lib/* $HOME/$DEXTER/lib
fi

pushd $HOME/$DEXTER/lib

cd Adafruit
sudo python setup.py install
sudo python3 setup.py install

popd


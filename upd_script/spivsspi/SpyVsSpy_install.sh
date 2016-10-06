#! /bin/bash

# This script installs bootup for Spi vs Spy.
# For wheezy versions, it will install and run from rc.local
# For Jessie versions, it will install and run with a systemd install

# Change to the home directory, clean up the home directory so we don't have a lot of file buildup there.
cd /home/pi/
sudo rm spyvsspi.*
sudo rm SpyVsSpy*
sudo rm SpyvsSpy*
sudo rm Mission1_pythonFile*

VERSION=$(sed 's/\..*//' /etc/debian_version)

if [ $VERSION -eq '7' ]; then
	echo "Version 7 found!  You have Wheezy!"
	# Edit rc.local
		sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/Mission1_pythonFile.py
	sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/SpyvsSpy_Startup.py

	sudo sed -i "/SpyvsSpy_Startup/d" /etc/rc.local		# Deletes any line with the word SpyvsSpy_Startup in it.
	sudo sed -i "/exit/d" /etc/rc.local	# Delets the exit.
	sudo echo "sudo python /home/pi/SpyvsSpy_Startup.py" >> /etc/rc.local	# Adds the line to rc.local to call SpyvsSpy at startup.
	sudo echo "exit 0" >> /etc/rc.local # Add that exit back in!


#jessie
elif [ $VERSION -eq '8' ]; then
	echo "Version 8 found!  You have Jessie!"
	sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/Mission1_pythonFile.py
	sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/SpyvsSpy_Startup.py
	sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/spyvsspi.service

	sudo cp spyvsspi.service /etc/systemd/system/spyvsspi.service
	sudo chown root:root /etc/systemd/system/spyvsspi.service
	sudo rm spyvspi.service

	echo "############################################################"
	sudo systemctl daemon-reload
	sudo systemctl enable spyvsspi.service
	echo "############################################################"
  
fi

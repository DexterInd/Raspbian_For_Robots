#! /bin/bash

VERSION=$(sed 's/\..*//' /etc/debian_version)

if [ $VERSION -eq '7' ]; then
	echo "Wheezy"
	sudo sed -i "/SpyvsSpy_Startup/d" /etc/rc.local		# Deletes any line with the word SpyvsSpy_Startup in it.

elif [ $VERSION -eq '8' ]; then
	echo "Jessie"
	sudo systemctl disable spyvsspi.service
	sudo systemctl daemon-reload
	if [ -f /etc/systemd/system/spyvsspi.service ]; then
		sudo rm /etc/systemd/system/spyvsspi.service
	fi
fi


HOME="/home/pi"

if [ -f $HOME/spyvsspi.* ]; then
	sudo rm $HOME/spyvsspi.*
fi
if [ -f $HOME/SpyVsSpy* ]; then
	sudo rm $HOME/SpyVsSpy*
fi
if [ -f $HOME/SpyvsSpy* ]; then
	sudo rm $HOME/SpyvsSpy*
fi
if [ -f $HOME/Mission1_pythonFile* ]; then
	sudo rm $HOME/Mission1_pythonFile*
fi


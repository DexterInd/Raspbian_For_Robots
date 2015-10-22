#! /bin/bash
echo "Update"
echo "This is a crossover for updating Dexter Industries Raspbian for Robots."
echo "This should update the 2015.03.20 image to the 2015.10 image."
echo "The only time you would run this is if you have an old version of the image.  This will update it to the latest version."

##############################################################################################################
# This is a crossover version for update.  This should update the 2015.03.20 image to the 2015.10 image.
##############################################################################################################
# 1.    Update the Source Files.  Pull the Raspbian for robots Github repo and put it in a subdirectory of pi.
#		Get the latest update information.

# If the directory exists, delete it.

if [ -d /home/pi/di_update ] ; then
	sudo rm -r /home/pi/di_update
fi

# Make the directory again.  Clone into it.  
mkdir /home/pi/di_update
cd /home/pi/di_update
sudo git clone https://github.com/DexterInd/Raspbian_For_Robots/
cd Raspbian_For_Robots

#
#
#
#
#
#
#
#
#
#
#
# Take this part out when you're done!
cd /home/pi/di_update/Raspbian_For_Robots/
git checkout update201507
#
#
#
#
#
#
#
#
#
#
#
# Make files executable.
echo "MAKE FILES EXECUTABLE."
echo "=============================="
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/update_master.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/raspbian_for_robots_update.py

# Run the update master program.  
sudo sh /home/pi/di_update/Raspbian_For_Robots/update_master.sh
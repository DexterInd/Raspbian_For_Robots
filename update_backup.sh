#! /bin/bash
# Nuclear Backup Option.  
# Run this with "sudo sh ~/update_backup.sh" in the command line.

sudo rm -r /home/pi/di_update

mkdir /home/pi/di_update
cd /home/pi/di_update
sudo git clone https://github.com/DexterInd/Raspbian_For_Robots/
cd Raspbian_For_Robots

cd /home/pi/di_update/Raspbian_For_Robots/
# git checkout update201507

sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/update_master.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/raspbian_for_robots_update.py

sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n --force-yes -y			# Install wx for python for windows / GUI programs.
echo "Installed wxpython tools"
sudo apt-get install python-psutil --force-yes -y
echo "Python-PSUtil"

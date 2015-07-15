#! /bin/bash
mkdir /tmp/di_update
wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/fetch.sh -O /tmp/di_update/update.sh
chmod +x /tmp/di_update/update.sh
sudo /tmp/di_update/update.sh
echo "Press Enter to EXIT"
read
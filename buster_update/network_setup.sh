sudo mkdir -p /boot/network
cd /boot/network

# copy important network files

## dhcpcd.conf
if ! [ -h /etc/dhcpcd.conf ]
then
sudo mv /etc/dhcpcd.conf /boot/network/.
sudo ln -fs /boot/network/dhcpcd.conf /etc/dhcpcd.conf
fi

## wpa_supplicant
if ! [  -h /etc/dhcpcd.conf ]
then
sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /boot/network/.
sudo ln -fs /boot/network/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
fi

## interfaces
if ! [ -h /etc/network/interfaces ]
then
sudo mv /etc/network/interfaces /boot/network/.
sudo ln -fs /boot/network/interfaces /etc/network/interfaces
fi

## interfaces.d folder
if ! [ -h /etc/network/interfaces.d ]
then
sudo cp -R /etc/network/interfaces.d /boot/network
sudo rm  -R /etc/network/interfaces.d
sudo ln -fs /boot/network/interfaces.d /etc/network/interfaces.d
fi

# add audio reading of the IP
if ! grep -q "sudo bash /home/pi/ip_feedback.sh" /etc/rc.local
then
    sudo sed -i '/exit 0/i sudo bash /home/pi/ip_feedback.sh' /etc/rc.local
fi

# copy ip_feedback.py into /home/pi
sudo cp /home/pi/di_update/Raspbian_For_Robots/buster_update/ip_feedback.sh /home/pi/ip_feedback.sh

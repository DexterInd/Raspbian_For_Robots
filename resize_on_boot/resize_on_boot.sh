
setup_resize_on_boot() {
    sudo cp /home/pi/di_update/Raspbian_For_Robots/resize_on_boot/init_resize.sh /usr/lib/raspi-config/init_resize.sh

    sudo cp /home/pi/di_update/Raspbian_For_Robots/resize_on_boot/resize2fs_once /etc/init.d/resize2fs_once
    sudo chmod 755 /etc/init.d/resize2fs_once

    sudo ln -s /etc/init.d/resize2fs_once /etc/rc3.d/S01resize2fs_once

    if ! grep "init_resize" /boot/cmdline.txt
    then
    sudo sed -i 's|rootwait|rootwait init=/usr/lib/raspi-config/init_resize.sh|' /boot/cmdline.txt
    fi
}


if [ ! -f "/home/pi/.resize_done_once" ]
then
    setup_resize_on_boot
    touch /home/pi/.resize_done_once
else
    echo "***************************************************************************"
    echo "resize on boot not set up because /home/pi/.resize_done_once exists already"
    echo "***************************************************************************"
fi

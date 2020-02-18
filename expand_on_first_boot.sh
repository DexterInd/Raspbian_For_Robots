if test -f /home/pi/first_boot; then
 sudo raspi-config --expand-rootfs
 sudo rm /home/pi/first_boot
fi

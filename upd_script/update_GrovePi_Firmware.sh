#! /bin/bash

echo "Beginning to Update the GrovePi Firmware!"
echo "============================="

pushd /home/pi/Dexter/GrovePi/Firmware
source /home/pi/Dexter/GrovePi/Firmware/grovepi_firmware_update.sh
update_grovepi_firmware
popd

echo "Finished updating the GrovePi Firmware!"
echo "============================="

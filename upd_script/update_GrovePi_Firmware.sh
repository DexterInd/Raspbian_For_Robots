#! /bin/bash

echo "Beginning to Update the GrovePi Firmware!"
echo "============================="

avrdude -c gpio -p m328p -U lfuse:w:0xFF:m
avrdude -c gpio -p m328p -U hfuse:w:0xDA:m
avrdude -c gpio -p m328p -U efuse:w:0x05:m
avrdude -c gpio -p m328p -U flash:w:/home/pi/Desktop/GrovePi/Firmware/grove_pi_firmware.hex

echo "Finished updating the GrovePi Firmware!"
echo "============================="

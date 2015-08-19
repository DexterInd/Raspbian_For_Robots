#! /bin/bash
# Add GoPiGo Firmware Update Button
sudo rm /home/pi/Desktop/desktop_shortcut_update_GoPiGo_Firmware.desktop
sudo cp /home/pi/di_update/Raspbian_For_Robots/desktop_shortcut_update_GoPiGo_Firmware.desktop /home/pi/Desktop
sudo chmod +x /home/pi/Desktop/desktop_shortcut_update_GoPiGo_Firmware.desktop
sudo chmod +x /home/pi/Desktop/GoPiGo/Firmware/firmware_update.sh

# Add GrovePi Firmware Update Button
sudo rm /home/pi/Desktop/desktop_shortcut_update_GrovePi_Fimware.desktop
sudo cp /home/pi/di_update/Raspbian_For_Robots/desktop_shortcut_update_GrovePi_Fimware.desktop /home/pi/Desktop
sudo chmod +x /home/pi/Desktop/desktop_shortcut_update_GrovePi_Fimware.desktop
sudo chmod +x /home/pi/Desktop/GrovePi/Firmware/firmware_update.sh
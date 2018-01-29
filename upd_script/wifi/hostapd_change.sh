#! /usr/bin/env bash
# This script is used to select between the Dexter external wifi adapter and Pi3 inbuilt wifi adapter.
# This script chooses the Wifi adapter if available and makes changes to hostapd.conf
#
#
# NOTE:
#      modprobe <module> - used to load kernel modules or drivers
#      rmmod <module> - used to remove loadable modules or drivers from kernel
#
# Testing:
# Testng this script alone requires some commands so
# 1. Uncomment the commands below "For testing". 
# 2. Have/or not the Dexter Wifi Adater plugged into the Pi- dependending on Dexter or Pi3  wifi adapter test.
# 3. Run the script.
#
#


# Command to search for Dexter wifi adapter
a=$(lsusb | grep -E "Realtek Semiconductor.*WLAN Adapter")
# For Testing
#sudo /etc/init.d/hostapd stop

# Check if search returns a null value
if [ -z "$a" ]
then    
    # Changes to use inbuilt Pi3 Wifi adapter
    # Copying the binary file compiled for Pi3 wifi adapter to /usr/local/bin/
    # To make hostapd use it for execution.
    sudo cp /usr/local/bin/hostapd_pi3_wifi /usr/local/bin/hostapd
    # Enabling wlan0 adapter which is blacklisted by cinch_setup.sh
    sudo sed -i '/^blacklist/s/^/#/g' /etc/modprobe.d/cinch-blacklist.conf
    # Commenting the Dexter Wifi adapter details in hostapd.conf
    sudo sed -i '/^driver/s/^/#/' /etc/hostapd/hostapd.conf
    sudo sed -i '/^device_name=RTL8192CU/s/^/#/' /etc/hostapd/hostapd.conf
    sudo sed -i '/^manufacturer=Realtek/s/^/#/' /etc/hostapd/hostapd.conf   
    sudo systemctl daemon-reload
    # To load kernel modules of Pi3 wifi adapter without reboot
    sudo modprobe brcmfmac
    sudo modprobe brcmutil
    # For Testing - Using these two lines add significant delay to boot so use it only for testing.
    #sudo /etc/init.d/networking stop 
    #sudo /etc/init.d/networking start
    
    # Reloading wlan0 interface to enable changes made to the kernel
    sudo ifdown wlan0
    sudo ifup wlan0
    
else
    # Changes to use Dexter Wifi adapter
    # Copying the binary file compiled for Dexter wifi adapter to /usr/local/bin/
    # To make hostapd use it for execution.
    sudo cp /usr/local/bin/hostapd_rtl_wifi /usr/local/bin/hostapd
    # Disabling wlan0 adapter as blacklisted by cinch_setup.sh
    sudo sed -i '/blacklist/s/^#//g' /etc/modprobe.d/cinch-blacklist.conf
    # Uncommenting the Dexter Wifi adapter details in hostapd.conf
    sudo sed -i '/driver/s/^#//' /etc/hostapd/hostapd.conf
    sudo sed -i '/device_name=RTL8192CU/s/^#//' /etc/hostapd/hostapd.conf
    sudo sed -i '/manufacturer=Realtek/s/^#//' /etc/hostapd/hostapd.conf
    sudo systemctl daemon-reload
    # When this script runs with Pi3 wifi adapter and then next time with Dexter wifi adapter, both wlan0 and wlan1
    # would have been enabled. All our hostapd,dnsmasq and wifi_channel_select use wlan0 interface. Hence have to remove
    # wlan1- Dexter wifi adapter module (as wlan0 is always assigned to Pi3 wifi adapter if its enabled).
    # Removing Dexter- Wifi adapter driver
    sudo rmmod 8192cu
    # Removing kernel modules of inbuilt pi3 wifi adapters
    sudo rmmod brcmfmac
    sudo rmmod brcmutil
    # Loading kernel modules of Dexter- Wifi adapter driver, so that it gets now assigned as wlan0 interface.
    sudo modprobe 8192cu
    #For testing
    #sudo /etc/init.d/networking stop 
    #sudo /etc/init.d/networking start
fi
#For testing
#sudo /etc/init.d/hostapd start 
#sudo /etc/init.d/dnsmasq restart

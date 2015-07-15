Create and edit a new file in /etc/modprobe.d/8192cu.conf
 sudo nano /etc/modprobe.d/8192cu.conf
and paste the following in
 # Disable power saving
options 8192cu rtw_power_mgnt=0 rtw_enusbss=1 rtw_ips_mode=1

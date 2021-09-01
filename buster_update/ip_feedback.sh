echo "starting"
COUNT=0
IPs=$(hostname --all-ip-addresses)
while [ -z "$IPs" ]
do
    echo "loop"
    sleep 1;
    IPs=$(hostname --all-ip-addresses)
    COUNT=$((COUNT+1))
    echo "count: "$COUNT > /home/pi/ipcount
done

echo "done looping "

echo "count: "$COUNT > /home/pi/ipcount

ifconfig wlan0 | grep 'inet ' | awk '{print $2}'  > /home/pi/ip.number
read -r IP_NUMBER < /home/pi/ip.number
echo $IP_NUMBER

# remove previous IP info
sudo rm /boot/*.assigned_ip &>/dev/null
sudo rm /home/pi/Desktop/*.assigned_ip &>/dev/null

# remove previous noWiFi IP
sudo rm /home/pi/failedIP &>/dev/null
sudo rm /home/pi/Desktop/failedIP &>/dev/null
sudo rm /home/pi/noWiFiIP &>/dev/null
sudo rm /home/pi/Desktop/noWiFiIP &>/dev/null

if [ ! -z "$IP_NUMBER" ]
then
        echo "saving IP info"
        sudo bash -c "echo $IP_NUMBER > /boot/$IP_NUMBER.assigned_ip"
        echo $IP_NUMBER > /home/pi/Desktop/$IP_NUMBER.assigned_ip
        echo "IP info saved"

        su -c "espeak-ng 'WiFi IP'" pi
        su -c "espeak-ng $IP_NUMBER" pi
        su -c "espeak-ng repeating "  pi
        su -c "espeak-ng $IP_NUMBER" pi
else
        su -c "espeak-ng 'No WiFi connection has been detected.'" pi
        echo ""no WiFi IP connection has been detected."
        echo "no WiFi IP connection has been detected." > /home/pi/noWiFiIP
        echo "no WiFi IP connection has been detected. " > /home/pi/Desktop/noWiFiIP

fi
echo "done with IP feedback"

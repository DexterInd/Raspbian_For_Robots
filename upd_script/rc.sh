#!/bin/bash -e
# This Script updates the hostname by reading it from "/boot/hostname" 
echo "  _____            _                                ";
echo " |  __ \          | |                               ";
echo " | |  | | _____  _| |_ ___ _ __                     ";
echo " | |  | |/ _ \ \/ / __/ _ \ '__|                    ";
echo " | |__| |  __/>  <| ||  __/ |                       ";
echo " |_____/ \___/_/\_\\__\___|_| _        _            ";
echo " |_   _|         | |         | |      (_)           ";
echo "   | |  _ __   __| |_   _ ___| |_ _ __ _  ___  ___  ";
echo "   | | | '_ \ / _    | | |   __| __|  | |/ _ \/ __| ";
echo "  _| |_| | | | (_| | |_| \__ \ |_| |  | |  __/\__ \ ";
echo " |_____|_| |_|\__,_|\__,_|___/\__|_|  |_|\___||___/ ";
echo "                                                    ";
echo "                                                    ";
echo " "

# First get the hostname.

# Now run the code in rc.local that updates the hostname.  

THISHOST=$(hostname -f) # Gets current hostname
echo $THISHOST
read -r NEW_HOST < /boot/hostnames  # Gets hostname in file
line=$(head -n 1 /boot/hostnames)
NEW_HOST=$line

echo $NEW_HOST
# echo $THISHOST

# sleep 5m


if [ "$NEW_HOST" != "$THISHOST" ];  # If the hostname isn't the same as the First line of the filename . . .

    then echo "Host is different name."
    REGEX="^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]))*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$";
    if [[ "$NEW_HOST" =~ $REGEX ]]; then
        echo $NEW_HOST > /home/pi/Desktop/hostname.log
        rm /home/pi/Desktop/Invalid_hostname.log
        echo "Rewriting hostname"

        # Rewrite hosts

        IP="127.0.1.1       $NEW_HOST"
        
        sudo rm /etc/hosts
        sudo sh -c "echo '127.0.0.1     localhost' >> /etc/hosts"
        sudo sh -c "echo '::1           ip6-localhost ip6-loopback' >> /etc/hosts"
        sudo sh -c "echo 'fe00::0       ip6-localnet' >> /etc/hosts"
        sudo sh -c "echo 'ff00::0       ip6-mcastprefix' >> /etc/hosts"
        sudo sh -c "echo 'ff02::1       ip6-allnodes' >> /etc/hosts"
        sudo sh -c "echo 'ff02::2       ip6-allrouters' >> /etc/hosts"
        sudo sh -c "echo ' ' >> /etc/hosts"            # Add that blank line in there.
        sudo sh -c "echo $IP >> /etc/hosts"

        echo "Delete hostname."

        sudo rm /etc/hostname
        echo "Deleted hostname.  Create new hostname."
        sudo echo $NEW_HOST >> /etc/hostname
        echo "New hostname file created."
        
        echo "Commit hostname change."
        sudo /etc/init.d/hostname.sh
    
        # sudo reboot
    else 

        echo "INVALID HOSTNAME"
                echo $NEW_HOST > /home/pi/Desktop/Invalid_hostname.log

    fi
fi

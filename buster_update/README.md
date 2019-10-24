# Raspbian Pi For Robots

This directory contains the scripts we used to upgrade BUSTER to Raspbian for Robots.  This is simply here for development purposes and so that it might be found to be useful to others.

# To Begin
+ Start with an image that has *Raspbian Buster with desktop* but not
*Raspbian Buster with desktop and recommended software*
https://downloads.raspberrypi.org/raspbian_latest

+ At the time of writing this readme, you will need to connect the new card to a screen so the desktop gets initialized once. Otherwise VNC won't work.
So might as well do the first steps on a screen.

Note: The Raspbian first boot now has a wizard to set the card up, you can choose to go through the wizard, or manually do the following:

# Basic Setup

1. sudo apt-get update && sudo apt-get -y upgrade (possibly done through the wizard already)

2. change password to robots1234

3. in raspi-config/interfacing Options:
    1. turn SSH on
    2. turn VNC on
    3. might as well turn camera/spi/i2c on too since we're here
    4. change hostname to dex
    5. go to Advanced Options and set resolution to 1024x768
    6. go to Localisation and set locale to en_US.UTF-8 and remove en_GB

4. connect to your wifi

5. Get Raspbian For Robots:

    `mkdir ~/di_update && cd di_update`

    `git clone https://github.com/DexterInd/Raspbian_For_Robots`

6. reboot. - if you have a VNC client you can be headless from now on.

# Install Robots

1. `bash di_update/Raspbian_For_Robots/buster_update/buster_update.sh`

2. go take a coffee or walk the dogs.

# novnc

1. Connect via VNC client (or keep screen and keyboard)

2. Click on the VNC icon:

    2.1. Click on hamburger menu, top right

    2.2. Select options
    2.3 Under Security:

        Encryption: prefer off
        Authentication:  VNC password
        Apply and set password to robots1234

    2.4 Under Connections:

        Set port to 5901

    2.5 Under Privacy:

        Unset `Disconnect users who have been idle for an extended period`.

    2.6 Under Updates

        Unset `Allow VNC server to check automatically`

3. add the systemd unit novnc.service

    `sudo cp ~/di_update/Raspbian_For_Robots/buster_update/novnc.service /etc/systemd/system/novnc.service`

Content should be:
```
[Unit]
Description = start noVNC service
After=syslog.target network.target

[Service]
Type=simple
User=pi
ExecStart = /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 8001

[Install]
WantedBy=multi-user.target
```

4. Enable the service

    `sudo systemctl enable novnc.service`

5. Start service to test once

    `sudo systemctl start novcn.service`

6. Connect to novnc with this url  (change  dex to actual IP if needed )

    http://dex:8001/vnc.html?port=8001&autoconnect=true&password=robots1234&scaleViewport=true

7. grab the novnc menu arrow on the left side and click on the gear icon

    7.1 select 'clip to Window' and "Local Scaling" for Scaling Mode.

8. reboot and try again

# Manual Installations

At the end of di_update/Raspbian_For_Robots/buster_update/Raspbian_for_Robots_Buster_Flavor.sh there are steps to be done manually.
Do not forget them!

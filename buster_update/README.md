# Raspbian Pi For Robots

This directory contains the scripts we used to upgrade BUSTER to Raspbian for Robots.  This is simply here for development purposes and so that it might be found to be useful to others.

# To Begin
+ Start with an image that has *Raspbian Buster with desktop* but not 
*Raspbian Buster with desktop and recommended software*
https://downloads.raspberrypi.org/raspbian_latest

At the time of writing this readme, you will need to connect the new card to a screen so the desktop gets initialized once. Otherwise VNC won't work.
So might as well do the first steps on a screen. 

1. change password to robots1234

2. in raspi-config:
    1. turn SSH on
    2. turn VNC on
    3. change hostname to dex
    4. go to Advanced Options and set resolution to 1024x768

3. connect to your wifi

4. reboot. - you can be headless from now on.

5. Connect via VNC (or keep screen and keyboard) 

6. sudo apt-get update && sudo apt-get -y upgrade

7. sudo apt-get install -y novnc websockify

8. Click on the VNC icon
    8.1. Click on hamburger menu, top right
    8.2. Select options
    8.3 Under Security:
        Encryption: prefer off
        Authentication:  VNC password
        Apply and set password to robots1234
    8.4 Under Connections:
        Set port to 5901

9. add the systemd unit novnc.service

[Unit]
Description = start noVNC service
After=syslog.target network.target

[Service]
Type=simple
User=pi
ExecStart = /usr/share/novnc/utils/launch.sh --vnc localhost:5901 --listen 8001

[Install]
WantedBy=multi-user.target

10. Enable the service
    sudo systemctl daemon-reload && sudo systemctl enable novnc@1.service

11. Start service to test once
    sudo systemctl start novcn.service

12. Connect to novnc with this url  (change IP accordingly)
    http://dex:8001/vnc.html?host=dex&port=8001&autoconnect=true&password=robots1234&scaleViewport=true

13. grab the novnc menu arrow on the left side and click on the gear icon
    13.1 select 'clip to Window' and "Local Scaling" for Scaling Mode.

14. reboot and try again

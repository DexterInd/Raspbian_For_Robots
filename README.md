# Raspbian Pi For Robots

![Dex Logo](dexter_industries_logo.jpg "Dexter Industries Logo.")

This is a customized version of the Raspbian Image for the Raspberry Pi.  It has been updated to help users get started quickly with Dexter Industries Robots.

## About
* See [more about Raspbian for Robots software here.](http://www.dexterindustries.com/raspberry-pi-robot-software/)
* See [another information page about Raspbian for Robots here.](http://www.dexterindustries.com/raspbian-for-robots/)
* See a troubleshooting [guide for Raspbian for Robots Here.](http://www.dexterindustries.com/raspbian-for-robots-support/)

This repository contains the latest and freshest updates to our software!

## Download
If all this looks too complicated, don't fear!  You can [download a pre-configured image with the latest software here.](http://sourceforge.net/projects/dexterindustriesraspbianflavor/)  

We have detailed step by step instructions on how to [install this image onto an SD Card here.](http://www.dexterindustries.com/howto/raspberry-pi-tutorials/install-raspbian-for-robots-image-on-an-sd-card/)

## Features

* Default hostname is dex.  Default user is pi.  The default password is robots1234.  VNC password is robots1234.
* Login on dex.local through your browser.
* Change the hostname directly on the sdcard.  Open "hostname" in a file editor and change the name to the hostname you desire.  Boot once, and restart to initiate the new hostname.
* noVNC available in the browser.  You can access from http://dex.local
* Terminal available in the browser.  You can access from http://dex.local
* Scratch Starter Program - Start Scratch for the different robots in the Dexter Industries Scratch Program.
* Test and Troubleshoot Program - We've added a Test and Troubleshoot program.
* Update Program - We have a dedicated program for updating the software, the operating system, and the firmware of your robot.
* Samba - Samba is installed.  The login credentials are "pi" and "robots1234".

## Host Name

You can change the hostname of your Raspberry Pi from "dex" to whatever you like.  This is particularly helpful if you have more than one Raspberry Pi on the same wifi network.  

Place the microSD card in the SD card adapter, and place in your PC or Mac.  Open the file "hostname" in a text editor.  It should say "dex" by default.  Change that name to whatever name you like, with no spaces, tabs or special characters.  And be sure to use lower case letters.  Save the file.  Replace the SD card in the Raspberry Pi and power it up.  Wait 5 minutes.  Remove the power to turn off the Raspberry Pi.  Power up the Raspberry Pi again.  The Raspberry Pi should have the new hostname.

## This Repository

These scripts manage to update the Raspbian for Robots image.  These changes are all executed using the Update button on the LXE Desktop of the Raspberry Pi.  

## Changes 2016-01-05
* Updated Avahi network settings.
* Updated IPV6 network settings.

## Cinch
We've developed a new way to connect using Cinch!  This lets you use wifi to tether to your robot.

## Testing
On each publication, we run [these tests](https://github.com/DexterInd/Utilities/blob/master/Raspbian_For_Robots_Testing/README.md) on a burned image to test it.


## License
All software here is released under the [GNU GL3 license.](http://www.gnu.org/licenses/gpl-3.0.txt)


    Originally written by John Cole and Karan Nayan for Dexter Industries.  This software updates your Raspberry Pi Operating System to work with Dexter Industries Hardware
    
    Copyright (C) <2015>  Dexter Industries

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.



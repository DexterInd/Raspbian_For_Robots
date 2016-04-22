# Raspbian Pi For Robots

Much of the directions and the workaround itself, as well as the serial overlay was downloaded from [Brian Dorey's website here.](http://www.briandorey.com/post/Raspberry-Pi-3-UART-Overlay-Workaround)

## Device Overlay Workaround

1. Download and install device tree overlay:
2. Download the boot overlay.  
```sudo wget https://github.com/DexterInd/Raspbian_For_Robots/raw/master/pi3/pi3-miniuart-bt-overlay.dtb```
3. Copy the overlay.  
```sudo cp pi3-miniuart-bt-overlay.dtb /boot/overlays```
4. Add the following lines to `/boot/config.txt`:
```	
dtoverlay=pi3-miniuart-bt-overlay
force_turbo=1
```
    
## FOR JESSIE:
    Move the bluetooth to use minuart using `dtoverlay=pi3-miniuart-bt` 
    Older directions:
        1. Disable the built in bluetooth `sudo systemctl disable hciuart`

## This Repository

These scripts manage to update the Raspbian for Robots image for the Raspberry Pi 3.

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



# Raspbian Pi For Robots

This directory contains the scripts we used to upgrade Jessie to Raspbian for Robots.  This is simply here for development purposes and so that it might be found to be useful to others.

# To Begin
From the home directory run `sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/regimen.sh`

From the home directory run `sudo sh regimen.sh`

From the home directory run `sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/jessie-heavy-upgrade.sh`

From the home directory run `sudo sh jessie-heavy-upgrade.sh`

## Manual Changes
A few manual changes need to be made:
- VNC Password must be set manually.

# What the files are:
**regimen.sh** is used to remove some packages from a full Jessie so it can fit on 4 Gig. Some repartitioning must be done manually.

**jessie-heavy-upgrade.sh** is used to make your Jessie into Raspbian for Robots. It will call all other scripts.

## sub scripts:
jessie_cleanup.sh : removes extra packages to make room for Raspbian for Robots
Raspbian_for_Robots_Flavor: changes everythin that is at the OS level to make it into Raspbian for Robots (passwords, VNC, etc)


## Changes 
* We'll document changes here in the future.

## License
All software here is released under the [GNU GL3 license.](http://www.gnu.org/licenses/gpl-3.0.txt)


    Originally written by John Cole for Dexter Industries.  This software updates your Raspberry Pi Operating System to work with Dexter Industries Hardware
    
    Copyright (C) <2016>  Dexter Industries

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



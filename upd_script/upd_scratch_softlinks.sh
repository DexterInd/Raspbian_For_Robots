#! /bin/bash
#######################################################
# This scripts adds the soft links that allows
# users to reach the Dexter Ind Scratch examples from
# within the Scratch interface
#######################################################

# BrickPi link

[ ! "$(readlink /usr/share/scratch/Project/BrickPi)" -ef "/home/pi/Desktop/BrickPi_Scratch/Examples" ] && sudo rm -r /usr/share/scratch/Projects/BrickPi
[ ! -d /usr/share/scratch/Projects/BrickPi ]  && sudo ln -s /home/pi/Desktop/BrickPi_Scratch/Examples /usr/share/scratch/Projects/BrickPi

# GoPiGo link
[ ! -d /usr/share/scratch/Projects/GoPiGo ]  && sudo ln -s /home/pi/Desktop/GoPiGo/Software/Scratch/Examples /usr/share/scratch/Projects/GoPiGo

# GrovePi Link
[ ! -d /usr/share/scratch/Projects/GrovePi ]  && sudo ln -s /home/pi/Desktop/GrovePi/Software/Scratch/Grove_Examples /usr/share/scratch/Projects/GrovePi



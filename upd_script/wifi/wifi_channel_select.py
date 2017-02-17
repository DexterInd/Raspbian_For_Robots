#! /usr/bin/python
#
# This script is used to select a felicitous wifi channel for the Sam access point.
#
# History
# -------------------------------------------------------
# Author              Date      	Comments
# Shoban Narayan      25 Jan 17  	Initial Authoring
# 	
#
# Algorithm
# -------------------------------------------------------
# 1.  Identify the number of devices using each wifi channel in the neighborhood and copy the information to a file-channel.txt. 
# 2.  Create a 2D list - (channel_list) with channel number and number of devices using the channel as its attributes.
# 3.  Count the channel occupancy of each channel in "channel.txt" and assign it to the corresponding channel on the channel_list. 
# 4.  Create a 2D list - (channel_check) for the non overlapping channels (1,6 & 11).
# 5.  Extract the information related to the non-overlapping channels in "channel_list" and assign them to corresponding channels in "channel_check".
# 6.  Sort the channel_check in descending order based on channel occupancy to find the least occupied channel among the non-overlapping channels.
# 7.  If the least occupancy among non-overlapping channels is less than 5(threshold) then choose the least occupied channel of channel_check.
# 8.  Else sort the channel_list in descending order based on channel occupancy and choose the least occupied channel among them.
# 9.  Stop the hostapd software to make changes in its configuration file.
# 10. Assign the chosen channel number to the channel attribute of /etc/hostapd/hostapd.conf file.
# 11. Start the hostapd software and find the access point using the chosen felicitous channel number.
#
# Ref: Facts about the wifi channel and its frequencies -http://www.radio-electronics.com/info/wireless/wi-fi/80211-channels-number-frequencies-bandwidth.php 
# Usage: This program is run on boot by channel_select file in /etc/init.d
# Uncomment the print statements to debug


from operator import itemgetter
import subprocess
import time

# Copy the channel occupancy to channel.txt
subprocess.call("sudo iwlist wlan0 scan | grep  \(Channel > channel.txt", shell=True)
    
# The number of channels in this algorithm is restricted to 11 while there are 14 wifi channels.
# This is since only 11 channels are available in USA.
# The first column on the list is the channel nuber and the second is the channel occupancy initialised to zero.
channel_list = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[8,0],[9,0],[10,0],[11,0]]

# Read the information in channel.txt
file  = open('channel.txt', 'r').read()

# Uncomment the line below to debug.
#print file 

for i in range (1,12):
	channel_no="(Channel "+str(i)+")"
	# Count the occupancy in each of the 11 channels
	count = file.count(channel_no)
	# Assign the count to the corresponding element of channel_list
	channel_list[i-1][1]=count
	# Uncomment the line below to debug.
	#print(" Count of Channel %d is %d"%(i,count))

# 2D list of non overlapping channels
channel_check=[[1,0],[6,0],[11,0]]
j=0

# Assigning the information related to non overlapping channels to channel_check
for i in range (1,12,5):
	channel_check[j][1]=channel_list[i-1][1]
	j=j+1

# Sorting the channel_check based on the channel occupancy, defined by column 1 of the list.
# key = itemgetter(1)- Sort the list based on the column 1(key).
# reverse = True - Sort in descending order.
channel_check.sort(key=itemgetter(1), reverse=True)

# Uncomment the line below to debug.
#print(channel_check)

# Preference given to non-overlapping channels as they will have the least interference from other channels. 
# To check if the least occupied channel among the non overlapping channels is less than equal to 5.
# If yes assign the least occupied channel among channel_check else assign the least occupied channel among channel_list.
if channel_check[2][1] <= 5:
	channel = channel_check[2][0]
else:
	channel_list.sort(key=itemgetter(1), reverse=True)
	channel = channel_check[10][0]

# Delete the channel.txt file
subprocess.call("sudo rm /home/pi/channel.txt", shell=True)

# Uncomment the line below to debug.
#print("The selected channel is %d "%channel)

# Stop the hostapd to modify its config file
subprocess.call("sudo /etc/init.d/hostapd stop", shell=True)
# Assign the chosen channel number to hostapd.conf file
subprocess.call("sed -i '/channel/c\channel='%s'' /etc/hostapd/hostapd.conf" %str(channel), shell=True)
# Start the hostapd 
subprocess.call("sudo /etc/init.d/hostapd start", shell=True)


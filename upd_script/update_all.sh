#! /bin/bash
# This script will do the updates.  This script can change all the time!
# This script should OFTEN be changed. 

sudo apt-get install python3-serial
# sudo apt-get update
# sudo apt-get upgrade
sudo apt-get clean

# Call fetch.sh
# This updates the Github Repositories.
sudo fetch.sh



echo "This is just a test script.  And it has run."


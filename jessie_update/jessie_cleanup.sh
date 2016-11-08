# this script is used to remove unwanted packages from Jessie, in order to create more room for Robotics stuff

# take a snapshot of all packages before we start
dpkg --get-selections | grep -v deinstall > packages_before.txt

# these packages are already removed in theory. But in case we choose another starting point, let's make sure they're gone
sudo apt-get purge -y wolfram-engine
sudo apt-get purge -y libreoffice*


# start serious purging
sudo apt-get purge -y greenfoot claws-mail* cryptsetup-bin
# this following one is questionable, it's not on Lite, so I'm taking it out, but it might be useful
sudo apt-get purge -y debian-reference-common debian-reference-en  

# We no longer remove minecraft which means we now require an 8Gig card for upcoming images
#sudo apt-get purge -y minecraft-pi

# note: removing supercollider will also remove sonic-pi. They seem to be linked
sudo apt-get purge -y supercollider*

# this line taken from jessie-heavy_upgrade, most are already not on the image, except the last two
# sudo apt-get remove gnome-mplayer yelp deluge claws-mail iceweasel lxmusic audacious transmission-gtk midori netsurf-gtk dillo -y
sudo apt-get remove dillo netsurf-gtk -y

# bring jessie up to date
sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get clean
sudo apt-get autoremove -y

# take a snapshot of all packages afterwards
dpkg --get-selections | grep -v deinstall > packages_after.txt

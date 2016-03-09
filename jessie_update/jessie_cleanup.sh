# this script is used to remove unwanted packages from Jessie, in order to create more room for Robotics stuff

# samba is needed to gain access to the drive on Windows
sudo apt-get install -y samba samba-common-bin
wget https://raw.githubusercontent.com/CleoQc/Raspbian_For_Robots/master/jessie_update/smbpasswd.txt
wget https://raw.githubusercontent.com/CleoQc/Raspbian_For_Robots/master/jessie_update/smb.conf
sudo cp smb.com /etc/samba/smb.conf
sudo service samba restart
sudo smbpasswd -a pi < smbpasswd.txt

# these packages are already removed in theory. But in case we choose another starting point, let's make sure they're gone
sudo apt-get purge -y wolfram-engine
sudo apt-get purge -y libreoffice*
sudo apt-get clean
sudo apt-get autoremove -y

# start serious purging
sudo apt-get purge -y greenfoot claws-mail* cryptsetup-bin
# this following one is questionable, it's not on Lite, so I'm taking it out, but it might be useful
sudo apt-get purge -y debian-reference-common debian-reference-en  

sudo apt-get purge -y minecraft-pi

# note: removing supercollider will also remove sonic-pi. They seem to be linked
sudo apt-get purge -y supercollider*

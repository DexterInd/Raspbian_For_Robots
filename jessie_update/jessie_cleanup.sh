# this script is used to remove unwanted packages from Jessie, in order to create more room for Robotics stuff

# samba is needed to gain access to the drive on Windows
sudo apt-get install -y samba samba-common-bin
sudo smbpasswd -a pi < smbpasswd.txt
# The following will need to be done manually to eventually give write access too.
# sudo nano /etc/samba/smb.conf
# security = user
# read only = no

# these packages are already removed in theory. But in case we choose another starting point, let's make sure they're gone
sudo apt-get purge -y wolfram-engine
sudo apt-get purge -y libreoffice*
sudo apt-get clean
sudo apt-get autoremove -y

# Get current list of packages
dpkg --get-selections | grep -v deinstall > packages.txt

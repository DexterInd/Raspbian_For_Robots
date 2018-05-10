# #########################################################################
# This script installs or updates noVNC on Raspbian for Robots - Stretch
#
# It is called when creating a new image 
#  ** AND **
# it is also called when doing a DI UPdate in update_all.sh
#
# #########################################################################

source $HOME/Dexter/lib/Dexter/script_tools/functions_library.sh

# Install noVNC
# this installation will only work if :
# 1. Apache is already installed
# 2. tightvncserver is already installed

feedback "--> install noVNC."
feedback "--> ======================================="
pushd /usr/local/share >/dev/null
sudo git clone --depth=1 --branch v1.0.0 https://github.com/novnc/noVNC.git
popd >/dev/null

# Setup Webpage
feedback "--> Set up dex.local webpage."
feedback "--> ======================================="
feedback " "
create_folder /var/www/novnc
sudo cp -r $HOME/di_update/Raspbian_For_Robots/VNC/www/* /var/www/novnc
sudo cp $PIHOME/di_update/Raspbian_For_Robots/www/index_stretch.php /var/www/novnc/index.php
sudo cp $PIHOME/di_update/Raspbian_For_Robots/www/css/main_stretch.css /var/www/novnc/css/main.css
sudo chmod +x /var/www/novnc/index.php
sudo chmod +x /var/www/novnc/css/main.css
sudo cp $HOME/di_update/Raspbian_For_Robots/VNC/001-novnc.conf /etc/apache2/sites-available
pushd /etc/apache2/sites-enabled >/dev/null
delete_file 000-default.conf
delete_file 001-novnc.conf
popd >/dev/null
feedback "--> restarting the apache server"
sudo /etc/init.d/apache2 reload
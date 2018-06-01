# #########################################################################
#
# This script installes Apache and all related libraries
# It then goes on to install tightvncserver, and noVNC
# Sets up Python for Apache
# #########################################################################
source $HOME/Dexter/lib/Dexter/script_tools/functions_library.sh

# this installs websockify, novnc, shellinabox
# assumed already installed: apache2 and tightvncserver

pushd $HOME/di_update/Raspbian_For_Robots/VNC >/dev/null


activate_python_for_apache() {
    # first activate CGI
    pushd /etc/apache2/mods-enabled >/dev/null
    sudo ln -s ../mods-available/cgid.conf .
    sudo ln -s ../mods-available/cgid.load .
    sudo ln -s ../mods-available/cgi.load .

    # give apache user proper rights
    sudo adduser www-data pi, i2c, spi
    # these groups seem to be useful in some fringe situations
    sudo adduser www-data gpio, staff, dialout

    if ! find_in_file cgi-bin /etc/apache2/conf-enabled
    then 
        echo "setting up python for apache"
    fi
    popd >/dev/null
}


feedback "--> install apache2, websockify, php."
feedback "--> ======================================="
sudo apt-get install apache2 websockify php libapache2-mod-php -y


VNC_FOLDER=$HOME/di_update/Raspbian_For_Robots/VNC/

bash $VNC_FOLDER/tightvncserver.sh
bash $VNC_FOLDER/novnc.sh

# at this point Apache is installed, so we'll do some settings on it
# to activate python
activate_python_for_apache

popd >/dev/null

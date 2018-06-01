######################################################################
# This script is meant to install the basics of Raspbian for Robots 
# onto a new Stretch image
# 
# It copies script_tools,
# removes unused programs,
# brings the image up to date,
# create the basic Dexter folder structure (minus any specific to robots),
# brings in RFR_Tools
# Installs tightvncserver and noVNC (including Apache2)
#
######################################################################

get_script_tools() {
    pushd $HOME >/dev/null
    curl -kL dexterindustries.com/update_tools | bash
    popd >/dev/null
}

clean_up() {
    # Clean up some fat
    sudo apt-get purge -y wolfram-engine
    sudo apt-get purge -y libreoffice*
    sudo apt-get purge -y supercollider*
    sudo apt-get purge -y minecraft-pi
    sudo apt-get remove dillo netsurf-gtk -y
}

update_stretch() {
    # get everything up to date
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get clean
    sudo apt-get autoremove -y
}

create_folders() {
    # create the main Dexter folders
    # but not the robot folders. They will be created by their own install scripts
    mkdir $HOME/Dexter
    mkdir $HOME/Dexter/lib
}

get_RFR_Tools() {
    pushd $HOME/Dexter/lib/Dexter >/dev/null
    git clone --depth=1 https://github.com/DexterInd/RFR_Tools.git
    popd >/dev/null
}

install_VNC() {
    bash ../VNC/install_all_vnc.sh
}


get_script_tools
source $HOME/Dexter/lib/Dexter/script_tools/functions_library.sh

clean_up
update_stretch
create_folders
get_RFR_Tools
install_VNC

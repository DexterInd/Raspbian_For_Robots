####################################
# installing tightvncserver
# many many thanks to Russell Davis for all the hints!
####################################
source $HOME/Dexter/lib/Dexter/script_tools/functions_library.sh

feedback "Installing tightvncserver"
sudo apt-get install tightvncserver -y

#install systemd service
sudo cp tightvncserver.service /etc/systemd/system/vncserver@.service
sudo systemctl daemon-reload && sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1.service

# change cursor
if ! find_in_file left_ptr $HOME/.vnc/xstartup 
then
    replace_first_this_with_that_in_file grey "grey -cursor_name left_ptr" $HOME/.vnc/xstartup 
fi
# sed -i 's/grey/grey -cursor_name left_ptr/g'  $HOME/.vnc/xstartup 
chmod +x $HOME/.vnc/xstartup

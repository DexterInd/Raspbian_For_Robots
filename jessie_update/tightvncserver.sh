####################################
# installing tightvncserver
# many many thanks to Russell Davis for all the hints!
####################################

# get default password from the argument
#DEFAULT_PWD=$1

#sudo apt-get install tightvncserver expect -y
#/usr/bin/expect <<EOF
#spawn "/usr/bin/tightvncserver"
#expect "Password:"
#send "$DEFAULT_PWD\r"
#expect "Verify:"
#send "$DEFAULT_PWD\r"
#expect "(y/n?"
#send "n\r"
#expect eof
#EOF
#sudo apt-get remove expect -y

# change cursor
sed -i 's/grey/grey -cursor_name left_ptr/g'  ./.vnc/xstartup 
chmod +x ./.vnc/xstartup

#install systemd service
wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/tightvncserver.service
sudo cp tightvncserver.service /etc/systemd/system/vncserver@.service
sudo systemctl daemon-reload && sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1.service

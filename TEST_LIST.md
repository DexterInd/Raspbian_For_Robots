# Raspbian for Robots Test List

This is testing for Raspbian for Robots.

General Tests:  Run and Check for Errors
=====================================
- [ ] Is Minecraft Installed?  `minecraft-pi`
- [ ] Shellinabox - Login and test. 
- [ ] noVNC - Login and test.
- [ ] VNC Viewer - Login and test. Verify that cursor is working.
- [ ] Dexter Industries Update - Run the DI Software Update once.
- [ ] Scratch GUI - Run the Scratch GUI.
- [ ] Test change the hostname. -> Preferences -> Raspberry Pi Configuration -> Hostname.  Change to dex1.
- [ ] Run as headless on a network.
- [ ] Run with an HDMI monitor, USB keyboard, USB mouse.
- [ ] Boot on the Pi 2
- [ ] Boot on the Pi 3

Desktop Tests:  Run These Programs to Make Sure They Work
=====================================
- [ ] Line Follower Calibration - verify files are saved in /home/pi/Dexter (black_line.txt, white_line.txt, range_line.txt)
- [ ] Backup Files
- [ ] Enable the IR receiver from *Advanced Communications Options* on the desktop and reboot
- [ ] Connect the IR receiver to the Serial port on the GoPiGo
- [ ] Run `sudo systemctl status ir-server.service` and check if IR server is running
- [ ] Run `ir_receiver_example.py` in /home/pi/Desktop/GoPiGo/Software/Python/ir_remote_control/gobox_ir_receiver_libs and press buttons on the remote and see if it works
- [ ] Check that folders appear for the detected robot and non-relevant folders get removed
- [ ] Connect a GoPiGo3 and PivotPi.  Do both folders appear on the Desktop?
- [ ] Check Copy/Paste in VNC (NOT noNVC).
- [ ] Check Geany is not run as root (try to edit a file in Dexter Python examples and you should be denied permission).

Robot Functional Testing:  Run the test with the hardware.
=====================================
- [ ] GrovePi: Run the GrovePi Hardware Test - `GrovePi/Software/Python/GrovePi_Hardware_Test.py`
- [ ] GrovePi: Use DI Software Update on Desktop to update the firmware of the GrovePi and GoPiGo to test AVRDude.
- [ ] GrovePi: Run Scratch Example Program
- [ ] GrovePi: Create new Scratch program
- [ ] GoPiGo: Test Desktop Control Panel
- [ ] GoPiGo: Run Scratch Example Program
- [ ] GoPiGo: Create new Scratch Program - example: broadcast forward
- [ ] GoPiGo: Test line follower in python.
- [ ] GoPiGo: Test and Troubleshoot should detect GoPiGo2.  Run Test and Demo.
- [ ] GoPiGo: Run Scratch Example - IR Sensor.
- [ ] GoPiGo3: Test Desktop Control Panel
- [ ] GoPiGo3: Update the Firmware from the Desktop
- [ ] GoPiGo3: Run the hardware test - `~/Dexter/GoPiGo3/Software/Python/Examples/Read_Info.py`
- [ ] GoPiGo3: Run a Python Example
- [ ] GoPiGo3: Run Scratch Example
- [ ] GoPiGo3: Test that `gopigo3_power.py` is running in the background when GoPiGo3 is attached.
- [ ] GoPiGo3: Test that you can power on and off with the button.
- [ ] GoPiGo3: Test line follower in python and scratch
- [ ] GoPiGo3: Test Python light sensor example in python and scratch
- [ ] GoPiGo3: Test Python IR Remote sensor example in python.
- [ ] GoPiGo3: Test Servo.py example
- [ ] GoPiGo3: Test and Troubleshoot should detect GoPiGo3.
- [ ] BrickPi3: Run the BrickPi3 Test - BrickPi3/Software/Python/Examples/Read_Info.py
- [ ] BrickPi3: Run Scratch Example Program
- [ ] BrickPi3: Create new Scratch program
- [ ] Arduberry: Check that Arduino IDE is 1.6.0 and test that Serial Echo with Hello world works
- [ ] BrickPi: Run the BrickPi Hardware Test - BrickPi_Python/Sensor_Examples/BrickPi_Hardware_Test.py
- [ ] BrickPi+: Run Scratch Example Program
- [ ] BrickPi+: Create new Scratch program - example: broadcast MAE, broadcast MA200

Branding and Cleanup:
=====================================
- [ ] Dexter industries Logo on Desktop.
- [ ] White Desktop Background.
- [ ] Is all wifi information removed?
- [ ] Is the trash can emptied?
- [ ] Is the Desktop Version updated?  Is the date the latest Version?
- [ ] Are the serial lines on by default?
- [ ] Is the camera enabled?  Run `sudo raspistill -o 1.jpg`
- [ ] Is the recovery script in place at ~/update_backup.sh ?

Publishing Tasks for Raspbian for Robots
=====================================
- [ ] Does it fit on a 4Gig Sandisk SD card? 
- [ ] Change version number in Desktop/Version
- [ ] Generate MD5
- [ ] Make MD5 Text file, Screenshot.
- [ ] Zip file
- [ ] Rar file
- [ ] Google Drive
- [ ] Sourceforge

Cinch
=====================================
- [ ] Does it fit on a 4Gig Sandisk SD card?  
- [ ] Run Cinch and connect with the DI Wifi Dongle
- [ ] Change hostname and run Cinch and connect - should use new SSID
- [ ] Run the uninstaller with and without the DI Wifi Dongle.

Publishing Tasks for Cinch
=====================================
- [ ] Reduce the Image Size with Piclone
- [ ] Generate MD5
- [ ] Make MD5 Text file, Screenshot.
- [ ] Zip file
- [ ] Rar file
- [ ] Google Drive
- [ ] Sourceforge

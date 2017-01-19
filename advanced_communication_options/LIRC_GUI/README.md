The IR receiver comes in 2 variants.  Version 1.0b comes with pin order GND,VCC,RX,NC pinout.  The newer version v1.2 comes with GND,VCC,NC and RX pinout. 

The GoBox will ship with the newer version so we are writing this software to that version.  We will have a script so that the older sensor works if someone asks for it in the forums.

The pinout of the newer sensor, GND,VCC,NC,RX makes the RX pin connected to the Serial TX pin on the Arduino side and then through the level convertor to the GPIO15,UART0_RX pin on the raspberry pi header, so we need to use pin 15 by default in  /etc/modules and /boot/config.txt.

The two critical files to modify are:
	*/etc/modules
	*/boot/config.txt


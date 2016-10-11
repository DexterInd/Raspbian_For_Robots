#!/usr/bin/python
import os
from time import sleep		# Allows us to call the sleep function to slow down our loop
import RPi.GPIO as GPIO		# Allows us to call our GPIO pins and names it just GPIO

sleep(30)

GPIO.setmode(GPIO.BCM)		# Set's GPIO pins to BCM GPIO numbering
INPUT_PIN_0 = 9				# GPI09
INPUT_PIN_1 = 11			# GPIO11

GPIO.setup(INPUT_PIN_0, GPIO.IN)           # Set our input pin to be an input
GPIO.setup(INPUT_PIN_1, GPIO.IN)           # Set our input pin to be an input


if((GPIO.input(INPUT_PIN_0) == True) and (GPIO.input(INPUT_PIN_1) == True)):
	print('True!')
	os.system("sudo python /home/pi/Mission1_pythonFile.py 1")
else:
	print('False!')

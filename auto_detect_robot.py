from __future__ import print_function
from __future__ import division

import time     # import the time library for the sleep function
from smbus import SMBus
import serial
from BrickPi import *
try:
	import brickpi3
except:
	pass

bus = SMBus(1)
detected_robot = "None"


def find_pivotpi():
    '''
    Boolean function that returns the presence of at least one PivotPi
    Checks all four possible addresses
    Returns True or False
    '''
    pivotpi_found = False
    try:
        import pivotpi
        possible_addresses = [0x40,
                              0x41,
                              0x42,
                              0x43]
        for add in possible_addresses:
            try:
                p = pivotpi.PivotPi(add)
                pivotpi_found = True
            except:
                pass
    except:
        pass
    return pivotpi_found


def find_gopigo():
    '''
    boolean function that detects the presence of a GoPiGo
    returns True or False
    '''
    gopigo_address = 0x08
    try:
        test_gopigo = bus.read_byte(gopigo_address)
        return True
    except:
        return False


def find_grovepi():
    '''
    boolean function that detects the presence of a GrovePi
    ONLY HANDLES DEFAULT GrovePi ADDRESS
    returns True or False
    '''
    grovepi_address = [0x04,
                       0x03,
                       0x05,
                       0x06,
                       0x07]
    grovepi_found = False
    for add in grovepi_address:
        try:
            test_grovepi = bus.read_byte(add)
            grovepi_found = True
        except:
            pass
    return grovepi_found


def find_brickpi():
    '''
    boolean function that detects the presence of a BrickPi+
    returns True or False
    '''
    BrickPiSetup()
    #if BrickPiSetupSensors() == 0: # really slow
    if BrickPiUpdateValues() == 0:
        return True
    else:
        return False


def find_brickpi3():
    '''
    boolean function that detects the presence of a BrickPi3
    returns True or False
    '''
    try:
        BP3 = brickpi3.BrickPi3()
        return True
    except:
        return False


def add_robot(in_robot):
    '''
    Add detected robot into a concatenated string,
    all robots are separated by a _
    '''
    global detected_robot

    if detected_robot != "None":
        detected_robot += "_"
    else:
        # get rid of the None as we do have something to add
        detected_robot = ""

    detected_robot += in_robot


def autodetect():
    '''
    Returns a string
    Possible strings are:
    GoPiGo
    GoPiGo_PivotPi
    GrovePi
    GrovePi_PivotPi
    GrovePi_GoPiGo
    GrovePi_GoPiGo_PivotPi
    PivotPi
    BrickPi
    BrickPi3
    BrickPi3_PivotPi
    '''
    global detected_robot
    detected_robot = "None"

# the order in which these are tested is important
# as it will determine the priority in Scratch    
    if find_gopigo():
        add_robot("GoPiGo")
    
    if find_brickpi3():
        add_robot("BrickPi3")

    if find_brickpi():
        add_robot("BrickPi")
    
    if find_grovepi():
        add_robot("GrovePi")

    if find_pivotpi():
        add_robot("PivotPi")

    print ("Detected {}".format(detected_robot))
    return detected_robot


if __name__ == '__main__':
    detected_robot = autodetect()
    with open("/home/pi/Dexter/detected_robot.txt", 'w+') as outfile:
        outfile.write(detected_robot)
        outfile.write('\n')

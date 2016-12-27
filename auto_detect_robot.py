from __future__ import print_function
from __future__ import division

import time     # import the time library for the sleep function
from smbus import SMBus
import serial

bus = SMBus(1)

detected_robot = "None"

def find_pivotpi():
    '''
    Boolean function that returns the presence of at least one PivotPi
    Checks all four possible addresses
    Returns True or False
    '''
    print("Looking for PivotPi")
    pivotpi_found = False
    try:
        import pivotpi
        possible_addresses = [  0x40,
                                0x41,
                                0x42,
                                0x43
                            ]
        for add in possible_addresses:
            try:
                # print("Testing {}".format(add))
                p = pivotpi.PivotPi(add)
                pivotpi_found = True
            except:
                # print ("Not found at {}".format(add))
                pass
    except:
        pass
    return pivotpi_found

def find_gopigo():
    '''
    boolean function that detects the presence of a GoPiGo
    returns True or False
    '''
    print("Looking for GoPiGo")
    gopigo_address = 0x08
    gopigo_found = False
    try:
        test_gopigo = bus.read_byte(gopigo_address) 
        print ("Found GoPiGo")
        gopigo_found = True
    except:
        pass
    return gopigo_found

def find_grovepi():
    '''
    boolean function that detects the presence of a GrovePi
    ONLY HANDLES DEFAULT GrovePi ADDRESS
    returns True or False
    '''
    print("Looking for GrovePi")
    grovepi_address = [0x04,0x03,0x05,0x06,0x07]
    grovepi_found = False
    for add in grovepi_address:
        try:
            test_grovepi = bus.read_byte(add)   
            print ("Found GrovePi at {}".format(add))
            grovepi_found = True
        except:
            pass
    return grovepi_found

def find_brickpi():
    '''
    TODO: not a valid method of detecting a BrickPi
    '''
    print("Looking for BrickPi")
    brickpi_found = False
    # ser = serial.Serial()
    # ser.port='/dev/ttyAMA0'
    # ser.baudrate=500000
    # ser.open()
    # if ser.isOpen():
    #     print("Found BrickPi or BrickPi+")
    #     brickpi_found = True

    return brickpi_found

def find_brickpi3():
    '''
    TODO: detect BrickPi3
    '''
    return False

def find_arduberry():
    '''
    TODO: detect arduberry
    '''

def add_robot(in_robot):
    '''
    Add detected robot into a concatenated string,
    all robots are separated by a _
    '''
    global detected_robot

    if detected_robot != "None":
        detected_robot +="_"
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
    Arduberry
    '''


    if find_gopigo():
        add_robot("GoPiGo")

    if find_grovepi():
        add_robot("GrovePi")

    if find_pivotpi():
        add_robot("PivotPi")

    if find_brickpi():
        add_robot("BrickPi")

    if find_brickpi3():
        add_robot("BrickPi3")

    if find_arduberry():
        add_robot("Arduberry")

    print ("Detected {}".format(detected_robot))
    return detected_robot

if __name__ == '__main__':
    detected_robot = autodetect()
    with open("/home/pi/Dexter/detected_robot.txt", 'w+') as outfile:
        outfile.write(detected_robot)
        outfile.write('\n')

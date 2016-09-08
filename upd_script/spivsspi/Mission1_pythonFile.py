#!/usr/bin/python
'''
Created by Conor Nelson, Principle Engineer for Tech Garden and Building Momentum
Created for use by Dexter Industries
July, 2016
'''

from grove_rgb_lcd import *
import time

##Definition that displays LCD text properly. Doesn't break up words etc.
def displayLCD_Text(string, timeDelay, colorLCD):
    tempLine = ''
    tempDisplay = ''
    tempStringList = string.split()
    firstLine = True

    setRGB(colorLCD[0],colorLCD[1],colorLCD[2])

    while tempStringList != list():

        while 16 - len(tempLine) >= len(tempStringList[0])+1:
            tempLine+=tempStringList[0]+" "
            del tempStringList[0]

            if tempStringList == list():
                if firstLine:
                    setText(tempLine)
                break
        
        if firstLine:
            tempLine+="\n"
            tempDisplay += tempLine
            tempLine = ''
            firstLine = False

        else:
            tempDisplay += tempLine
            setText(tempDisplay)
            tempDisplay = ''
            tempLine = ''
            firstLine = True
            
        time.sleep(timeDelay)

def main():

    string1 = "Loading."
    string2 = "Loading.."
    string3 = "Loading..."
    string4 = "Welcome SPI"
    string5 = "Dexteria has been keeping an eye on you. \
        Do you have what it takes to be a Top Level Spi \
        in our secret organization?"
    colorYellow = (255,255,0)
    colorWhite = (255,255,255)
    it = 0
    while it < 3:
        displayLCD_Text(string1,0.75,colorYellow )
        displayLCD_Text(string2,0.75,colorYellow )
        displayLCD_Text(string3,0.75,colorYellow )
        it+=1
        
    displayLCD_Text(string4,3.5,colorWhite )
    displayLCD_Text(string5,3.5,colorWhite )

main()
   



import wx
import os
import sys
import pickle
from datetime import datetime
import subprocess
from collections import Counter
import threading
import psutil
import signal
try:
    import auto_detect_robot
except:
    pass

robots = {}
robotbitmap = None


#	This program runs various update programs for Raspbian for Robots, from Dexter Industries.
#	See more about Dexter Industries at http://www.dexterindustries.com
'''
    This program is started from the script /home/pi/di_update/Raspbian_For_Robots/update_master.sh
    From this program you will be able to:
        1.  Update the OS.  This should update the Raspbian operating system.
        2.  Update DI Software.   This will update the Raspbian for Robots software, including the source and example files.
        3.  Update DI Hardware.   This will update the firmware for the GrovePi and the GoPiGo.

    Initially Authored:		10/1/2015
    Last Update:			4/May/2018
'''

# Developer Notes and References:
# http://www.blog.pythonlibrary.org/2010/03/18/wxpython-putting-a-background-image-on-a-panel/
# ComboBoxes!  		http://wiki.wxpython.org/AnotherTutorial#wx.ComboBox

PIHOME="/home/pi"
DEXTER="Dexter"
SCRATCH="Scratch_GUI"
s = "/";
seq = (PIHOME, DEXTER,"lib",DEXTER,SCRATCH) # This is sequence of strings.
SCRATCH_PATH = s.join( seq )+"/"

# Writes debug to file "error_log"
def write_debug(in_string):
    # In in time logging.
    #print in_string
    write_string = str(datetime.now()) + " - " + in_string + "\n"
    error_file = open('error_log', 'a')		# File: Error logging
    error_file.write(write_string)
    error_file.close()

def detect():
    try:
        detected_robots=auto_detect_robot.autodetect()
        print (detected_robots)
        # handling it this way to cover the cases of 
        # multiple robot detection
        if detected_robots.find("GoPiGo3") != -1:
            write_state("GoPiGo3")
        elif detected_robots.find("GoPiGo") != -1 and detected_robots.find("3") == -1:
            write_state("GoPiGo")
        elif detected_robots.find("BrickPi3")==0:
            write_state("BrickPi3")
        elif detected_robots.find("GrovePi")==0:
            write_state("GrovePi")
        else:
            write_state('dex')
    except Exception as e:
            write_state("dex")
            print(e)

def write_state(in_string):
    try:
        selected_robot = open('/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/selected_state', 'w')		# File: selected state
        if(' ' in in_string): 
            in_string = "dex"
        selected_robot.write(in_string)
        selected_robot.close()
    except:
        pass
    print ("write_state: {}".format(in_string))

def read_state():
    try:
        selected_robot = open('/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/selected_state', 'r')		# File: selected state
        in_string = selected_robot.read()
        selected_robot.close()
    except:
        in_string = "dex"
    print ("read_state: {}".format(in_string))
    return in_string

# This code is to allow customers to choose which robot they want to upgrade
# def write_robots_to_update():
# 	try:
# 		robots_2_update_file = open('/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/robots_2_update','w')
# 		for robot in robots:
# 			if robots[robot].GetValue():
# 				robots_2_update_file.write(robot+'\n')
# 		robots_2_update_file.close()
# 	except:
# 		pass

    
def send_bash_command(bashCommand):
    # print bashCommand
    write_debug(bashCommand)
    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE) #, stderr=subprocess.PIPE)
    # print process
    output = process.communicate()[0]
    # print output
    return output

def send_bash_command_in_background(bashCommand):
    # Fire off a bash command and forget about it.
    write_debug(bashCommand)
    process = subprocess.Popen(bashCommand.split())

########################################################################
class MainPanel(wx.Panel):
    """"""
    #----------------------------------------------------------------------
    def __init__(self, parent):
        global robots
        global update_firmware_static
        global robotbitmap
        """Constructor"""
        wx.Panel.__init__(self, parent=parent)
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.SetBackgroundColour(wx.WHITE)
        self.frame = parent
 
        Sizer = wx.BoxSizer(wx.VERTICAL)  # outside sizer. Contains 3 horizontal sizers
        topSizer = wx.BoxSizer(wx.HORIZONTAL) # top logo
        hSizer = wx.BoxSizer(wx.HORIZONTAL) # main
        bottomSizer = wx.BoxSizer(wx.HORIZONTAL)    # static text

        # hSizer contains 2 vertical sizer
        vSizerLeft = wx.BoxSizer(wx.VERTICAL)
        vSizerRight = wx.BoxSizer(wx.VERTICAL) # for robot image
 

        # TOP SIZER WITH LOGO

        logoSizer = wx.BoxSizer(wx.VERTICAL)
        bmp = wx.Bitmap(SCRATCH_PATH+"dex.png",type=wx.BITMAP_TYPE_PNG)
        logo=wx.StaticBitmap(self,bitmap=bmp)
        logoSizer.Add(logo,0,wx.RIGHT|wx.LEFT|wx.EXPAND)
        topSizer.Add(logoSizer)

        # LEFT SIZER

        # Update DI Software
        update_software_label = wx.StaticText(self, label="Libraries and Projects:")
        update_software = wx.Button(self, label="Update Dexter Software")
        update_software.Bind(wx.EVT_BUTTON, self.update_software)	

        #-------------------------------------------------------------------
        # Update Firmware

        update_firmware_label = wx.StaticText(self, label="Firmware:")
        update_firmware = wx.Button(self, label="Update Robot")
        update_firmware.Bind(wx.EVT_BUTTON, self.update_firmware)
        update_firmware.Bind(wx.EVT_ENTER_WINDOW, self.hovertxt_on)
        update_firmware.Bind(wx.EVT_LEAVE_WINDOW, self.hovertxt_off)

        # Drop Boxes
        controls = ['Choose your robot', 'GoPiGo3', 'GoPiGo', 'GrovePi', 'BrickPi3']	# Options for drop down.
        # Select Platform.
        folder = read_state()
        if folder in controls[1:]: # skip 'Choose your robot'
            print("setting drop down to {}".format(folder))
            robotDrop = wx.ComboBox(self, -1, str(folder),  choices=controls, style=wx.CB_READONLY)  # Drop down setup
        else:
            print ('default drop down')
            robotDrop = wx.ComboBox(self, -1, "Choose your Robot",  choices=controls, style=wx.CB_READONLY)  # Drop down setup
        robotDrop.Bind(wx.EVT_COMBOBOX, self.robotDrop)					# Binds drop down.		
        #robotDrop.Bind(wx.EVT_ENTER_WINDOW, self.hovertxt_on)
        #robotDrop.Bind(wx.EVT_LEAVE_WINDOW, self.hovertxt_off)

        vSizerLeft.AddSpacer(5)
        vSizerLeft.Add(update_software_label)
        vSizerLeft.Add(update_software, 0, wx.EXPAND)
        vSizerLeft.AddSpacer(45)
        vSizerLeft.Add(update_firmware_label)
        vSizerLeft.Add(update_firmware, 0, wx.EXPAND)
        vSizerLeft.Add(robotDrop)
        vSizerLeft.AddSpacer(10)



        # RIGHT SIZER
        icon_sizer = wx.BoxSizer(wx.VERTICAL)
        robot = read_state()+".png"
        print(robot)
        bmp = wx.Bitmap(SCRATCH_PATH+robot,type=wx.BITMAP_TYPE_PNG)
        robotbitmap=wx.StaticBitmap(self,bitmap=bmp)
        bmpW,bmpH = robotbitmap.GetSize()
        icon_sizer.Add(robotbitmap,1,wx.RIGHT|wx.LEFT|wx.EXPAND| wx.ALIGN_TOP)

        vSizerRight.Add(icon_sizer)


        # BOTTOM SIZER: static text plus exit button

        # Exit
        exit_button = wx.Button(self, label="Exit")
        exit_button.Bind(wx.EVT_BUTTON, self.onClose)

        update_firmware_static = wx.StaticText(self,-1,"Use this to update the robot firmware.\nThis only needs to be done occasionally! \nIf you have questions, \nplease ask on our forums!")
        bottomSizer.AddSpacer(20)
        bottomSizer.Add(update_firmware_static, 1, wx.EXPAND| wx.RESERVE_SPACE_EVEN_IF_HIDDEN)
        bottomSizer.Add(exit_button, 1, wx.RIGHT)
        bottomSizer.AddSpacer(40)

        hSizer.AddSpacer(30)
        hSizer.Add(vSizerLeft,0,wx.EXPAND)
        hSizer.AddSpacer(10)
        hSizer.Add(vSizerRight,0,wx.EXPAND)
        hSizer.AddSpacer(30)

        Sizer.AddSpacer(5)
        Sizer.Add(topSizer,1,wx.EXPAND)
        Sizer.Add(hSizer,1, wx.EXPAND)
        Sizer.Add(bottomSizer, 1, wx.EXPAND)
        self.SetSizer(Sizer)
        update_firmware_static.Hide()
    
        # self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)		# Sets background picture
 
        #send_bash_command_in_background("clear")

    # RobotDrop
    # This is the function called whenever the drop down box is called.
    def robotDrop(self, event):
        global robotbitmap
        write_debug("robotDrop Selected.")
        controls = ['dex', 'GoPiGo3', 'GoPiGo', 'GrovePi', 'BrickPi3']	# Options for drop down.
        value = event.GetSelection()
        print controls[value]
        # position = 0					# Position in the key list on file
        write_state(controls[value]) 	# print value to file.  
        
        # Update Picture
        robot = "/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/"+read_state()+".png"
        robot = read_state()+".png"
        newrobotbitmap = wx.Bitmap(SCRATCH_PATH+robot,type=wx.BITMAP_TYPE_PNG)
        robotbitmap.SetBitmap(newrobotbitmap)

    # Update the Operating System.
    def update_raspbian(self, event):
        write_debug("update_raspbian")
        dlg = wx.MessageDialog(self, 'Operating System Update will start!  Depending on your internet speed this could take a few hours.  Please do not close the terminal window or restart the update.', 'Alert!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        ran_dialog = False
        if dlg.ShowModal() == wx.ID_OK:
            start_command = "sudo sh /home/pi/di_update/Raspbian_For_Robots/update_os.sh"
            send_bash_command_in_background(start_command)
            print "Start Operating System update!"
            ran_dialog = True
        else:
            print "Cancel Operating System Update!"
        dlg.Destroy()
        
        write_debug("Cancel Operating System Update.")

    # Update the Software.
    def update_software(self, event):
        write_debug("Update Dexter Software")	
        # write_robots_to_update() # Taking out for now.  This would update the write_robots_to_update file.
        dlg = wx.MessageDialog(self, 'Software update will start.  Please do not close the terminal window or restart the update.', 'Alert!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        
        ran_dialog = False
        if dlg.ShowModal() == wx.ID_OK:
            start_command = "sudo bash /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh"
            send_bash_command_in_background(start_command)
            print "Start software update!"
            ran_dialog = True
        else:
            print "Cancel Software Update!"
        dlg.Destroy()
        
        write_debug("Update Dexter Software Finished.")
        
    def update_firmware(self, event):
    
        ran_dialog = False		# For the first loop of choices.
        show_dialog = False		# For the second loop of choices.
        
        write_debug("Update Dexter firmware")	
        folder = read_state()
        if folder == 'dex':
            dlg = wx.MessageDialog(self, 'Use the dropdown to select the hardware to update.', 'Alert!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
            program = " "
            show_dialog = False
        elif folder == 'GoPiGo3':
            program = "/home/pi/Dexter/GoPiGo3/Firmware/gopigo3_flash_firmware.sh"
            dlg = wx.MessageDialog(self, 'We will begin the firmware update.', 'Firmware Update', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
            show_dialog = True
        elif folder == 'GoPiGo':
            program = "/home/pi/di_update/Raspbian_For_Robots/upd_script/update_GoPiGo_Firmware.sh"
            dlg = wx.MessageDialog(self, 'We will begin the firmware update.', 'Firmware Update', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
            show_dialog = True
        elif folder == 'GrovePi':
            program = "/home/pi/di_update/Raspbian_For_Robots/upd_script/update_GrovePi_Firmware.sh"
            dlg = wx.MessageDialog(self, 'We will begin the firmware update.', 'Firmware Update', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
            show_dialog = True
        elif folder == 'BrickPi3':
            program = "/home/pi/Dexter/BrickPi3/Firmware/brickpi3samd_flash_firmware.sh"
            dlg = wx.MessageDialog(self, 'We will begin the firmware update.', 'Firmware Update', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
            show_dialog = True


        ran_dialog = False
        if ((dlg.ShowModal() == wx.ID_OK) and (show_dialog)):
            if folder == 'GoPiGo':
                # If we're doing a GoPiGo Firmware update, we NEED to prompt the user, ONE MORE TIME to disconnect the motors.
                dlg2 = wx.MessageDialog(self, 'DISCONNECT THE MOTORS!  Before firmware update, disconnect the motors from the GoPiGo or you risk damaging the hardware.', 'DISCONNECT MOTORS!', wx.OK|wx.ICON_EXCLAMATION)
                dlg2.ShowModal()
                dlg2.Destroy()
            start_command = "sudo bash "+program
            # send_bash_command_in_background(start_command)
            print "Start Firmware test!" + str(folder)
            print send_bash_command(start_command)
            # send_bash_command(program)
            ran_dialog = True
        else:
            print "Cancel Firmware Update!"
        dlg.Destroy()
        
        # Depending on what the user chose, we either cancel or complete.  
        if ran_dialog:
            dlg = wx.MessageDialog(self, 'Firmware update is done!', 'Begin', wx.OK|wx.ICON_INFORMATION)
            dlg.ShowModal()
            dlg.Destroy()
        else:
            dlg = wx.MessageDialog(self, 'Firmware update is canceled.', 'Canceled', wx.OK|wx.ICON_HAND)
            dlg.ShowModal()
            dlg.Destroy()
        
        write_debug("Programming Started.")	

    def hovertxt_on(self,event):
        #print("HOVERING")
        update_firmware_static.Show()
        event.Skip()

    def hovertxt_off(self,event):
        #print("HOVERING")
        update_firmware_static.Hide()
        event.Skip()
    
    def onClose(self, event):	# Close the entire program.
        write_debug("Close Pressed.")
        # dlg = wx.MessageDialog(self, 'The Pi will now restart.  Please save all open files before pressing OK.', 'Alert!', wx.OK|wx.ICON_INFORMATION)
        # dlg.ShowModal()
        # dlg.Destroy()
        dlg = wx.MessageDialog(self, 'You must reboot for changes to take effect.  Reboot now?', 'Reboot', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        if dlg.ShowModal() == wx.ID_OK:
            # Reboot
            send_bash_command('sudo reboot')
        else: 
            # Do nothing.
            print "No reboot."
        dlg.Destroy()
        """
        """
        self.frame.Close()

  
########################################################################
class MainFrame(wx.Frame):
    """"""
    
    #----------------------------------------------------------------------
    def __init__(self):
        """Constructor"""
        # wx.ComboBox

        wx.Icon('/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/favicon.ico', wx.BITMAP_TYPE_ICO)
        wx.Log.SetVerbose(False)
        wx.Frame.__init__(self, None, title="Dexter Industries Update")		# Set the frame size

        panel = MainPanel(self)        
        self.Center()
 
########################################################################
class Main(wx.App):
    """"""
 
    #----------------------------------------------------------------------
    def __init__(self, redirect=False, filename=None):
        """Constructor"""
        wx.App.__init__(self, redirect, filename)
        dlg = MainFrame()
        dlg.Show()
 
#----------------------------------------------------------------------
if __name__ == "__main__":
    send_bash_command_in_background("xhost +")
    write_debug(" # Program # started # !")
    detect()
    # reset_file()	#Reset the file every time we turn this program on.
    app = Main()
    app.MainLoop()

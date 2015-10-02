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

#	This program runs various update programs for Raspbian for Robots, from Dexter Industries.
#	See more about Dexter Industries at http://www.dexterindustries.com
'''
	This program is started from the script /home/pi/di_update/Raspbian_For_Robots/update_master.sh
	From this program you will be able to:
		1.  Update the OS.  This should update the Raspbian operating system.
		2.  Update DI Software.   This will update the Raspbian for Robots software, including the source and example files.
		3.  Update DI Hardware.   This will update the firmware for the GrovePi and the GoPiGo.

	Initially Authored:		10/1/2015
	Last Update:			10/1/2015
'''

# Developer Notes and References:
# http://www.blog.pythonlibrary.org/2010/03/18/wxpython-putting-a-background-image-on-a-panel/
# ComboBoxes!  		http://wiki.wxpython.org/AnotherTutorial#wx.ComboBox

# Writes debug to file "error_log"
def write_debug(in_string):
	# In in time logging.
	#print in_string
	write_string = str(datetime.now()) + " - " + in_string + "\n"
	error_file = open('error_log', 'a')		# File: Error logging
	error_file.write(write_string)
	error_file.close()

def write_state(in_string):
	error_file = open('/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/selected_state', 'w')		# File: selected state
	if(' ' in in_string): 
		in_string = "dex"
	error_file.write(in_string)
	error_file.close()

def read_state():
	error_file = open('/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/selected_state', 'r')		# File: selected state
	in_string = ""
	in_string = error_file.read()
	error_file.close()
	return in_string
	
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
		"""Constructor"""
		wx.Panel.__init__(self, parent=parent)
		self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
		self.frame = parent
 
		sizer = wx.BoxSizer(wx.VERTICAL)
		hSizer = wx.BoxSizer(wx.HORIZONTAL)
 
		wx.StaticText(self, -1, "Raspbian For Robots Update", (25, 5))					# (Minus 50, minus 0)
 
		#-------------------------------------------------------------------
		# Standard Buttons

		# Upate Raspbian
		update_raspbian = wx.Button(self, label="Update Raspbian", pos=(25,50))
		update_raspbian.Bind(wx.EVT_BUTTON, self.update_raspbian)
		
		# Update DI Software
		update_software = wx.Button(self, label="Update Dexter Software", pos=(25, 100))
		update_software.Bind(wx.EVT_BUTTON, self.update_software)			
		
		# Update Firmware
		update_firmware = wx.Button(self, label="Update Hardware Firmware", pos=(25,150))
		update_firmware.Bind(wx.EVT_BUTTON, self.update_firmware)

		# Exit
		exit_button = wx.Button(self, label="Exit", pos=(25,250))
		exit_button.Bind(wx.EVT_BUTTON, self.onClose)
	
		# End Standard Buttons		
		#-------------------------------------------------------------------
		# Drop Boxes

		controls = [' ', 'GoPiGo', 'GrovePi']	# Options for drop down.

		# Select Platform.
		
		robotDrop = wx.ComboBox(self, -1, " ", pos=(25, 200), size=(150, -1), choices=controls, style=wx.CB_READONLY)  # Drop down setup
		robotDrop.Bind(wx.EVT_COMBOBOX, self.robotDrop)					# Binds drop down.		
		
		# Drop Boxes
		#-------------------------------------------------------------------
		
		hSizer.Add((1,1), 1, wx.EXPAND)
		hSizer.Add(sizer, 0, wx.TOP, 100)
		hSizer.Add((1,1), 0, wx.ALL, 75)
		self.SetSizer(hSizer)
	
		self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)		# Sets background picture
 
	#----------------------------------------------------------------------
	def OnEraseBackground(self, evt):
		"""
		Add a picture to the background
		"""
		# yanked from ColourDB.py
		dc = evt.GetDC()
 
		if not dc:
			dc = wx.ClientDC(self)
			rect = self.GetUpdateRegion().GetBox()
			dc.SetClippingRect(rect)
		dc.Clear()	
		# bmp = wx.Bitmap("/home/pi/Desktop/DexterEd/Scratch_GUI/dex.png")	# Draw the photograph.
		# dc.DrawBitmap(bmp, 0, 400)						# Absolute position of where to put the picture
		
		# Add a second picture.
		robot = "/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/"+read_state()+".png"
		bmp = wx.Bitmap(robot)	# Draw the photograph.
		dc.DrawBitmap(bmp, 200, 0)	
		
	# RobotDrop
	# This is the function called whenever the drop down box is called.
	def robotDrop(self, event):
		write_debug("robotDrop Selected.")
		controls = ['dex', 'GoPiGo', 'GrovePi']	# Options for drop down.
		value = event.GetSelection()
		print controls[value]
		# position = 0					# Position in the key list on file
		write_state(controls[value]) 	# print value to file.  
		
		# Update Picture
		robot = "/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/"+read_state()+".png"
		png = wx.Image(robot, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
		wx.StaticBitmap(self, -1, png, (200, 0), (png.GetWidth(), png.GetHeight()))

	# Update the Operating System.
	def update_raspbian(self, event):
		write_debug("update_raspbian")	
		dlg = wx.MessageDialog(self, 'Operating System Update has started!  Depending on your internet speed this could take a few hours.  Please do not close the terminal window or restart the update.', 'Alert!', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		start_command = "sudo sh /home/pi/di_update/Raspbian_For_Robots/update_os.sh"
		send_bash_command_in_background(start_command)

	# Update the Software.
	def update_software(self, event):
		write_debug("Update Dexter Software")	
		dlg = wx.MessageDialog(self, 'Software update will start.  Please do not close the terminal window or restart the update.', 'Alert!', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		start_command = "sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh"
		send_bash_command_in_background(start_command)
		
		write_debug("Update Dexter Software Finished.")	
		
	def update_firmware(self, event):
		write_debug("Update Dexter Software")	

		folder = read_state()

		if folder == 'dex':
			dlg = wx.MessageDialog(self, 'Use the dropdown to select the hardware to update.', 'Alert!', wx.OK|wx.ICON_INFORMATION)
			dlg.ShowModal()
			dlg.Destroy()
		elif folder == 'GoPiGo':
			program = "/home/pi/di_update/Raspbian_For_Robots/upd_script/update_GoPiGo_Firmware.sh"
		elif folder == 'GrovePi':
			program = "/home/pi/di_update/Raspbian_For_Robots/upd_script/update_GrovePi_Firmware.sh"
		start_command = "sudo sh "+program
		send_bash_command_in_background(start_command)
		
		write_debug("Programming Started.")	
		
	def onClose(self, event):	# Close the entire program.
		write_debug("Close Pressed.")
		dlg = wx.MessageDialog(self, 'The Pi will now restart.  Please save all open files before pressing OK.', 'Alert!', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
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
		wx.Frame.__init__(self, None, title="Update Raspbian for Robots", size=(400,300))		# Set the frame size

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
	write_state("dex")
	# reset_file()	#Reset the file every time we turn this program on.
	app = Main()
	app.MainLoop()

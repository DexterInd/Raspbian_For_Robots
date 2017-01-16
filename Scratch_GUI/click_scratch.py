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
from auto_detect_robot import *

#	This program runs when a Scratch program is clicked on the desktop.
#	It should be called by a modified script in /usr/bin/scratch to start.
#	It will:
# 		- First allow a user to specify which platform they want to run (GrovePi, GoPiGo, PivotPi or BrickPi)
#		- Second kill all Scratch programs.
#		- Third start the appropriate background program (GrovePi, GoPiGo, BrickPi, PivotPi)
# 		- Kill itself.
#	After the program is run, /usr/bin/scratch will start Scratch, opening the file.

# References
# http://www.blog.pythonlibrary.org/2010/03/18/wxpython-putting-a-background-image-on-a-panel/
# ComboBoxes!  		http://wiki.wxpython.org/AnotherTutorial#wx.ComboBox
# dfu-programmer:  	http://dfu-programmer.github.io/


PIHOME="/home/pi"
DEXTER="Dexter"
SCRATCH="Scratch_GUI"
SCRATCH_PATH = PIHOME+"/"+DEXTER+"/lib/"+DEXTER+"/"+SCRATCH+"/"


# Writes debug to file "error_log"
def write_debug(in_string):
	# In in time logging.
	#print in_string
	write_string = str(datetime.now()) + " - " + in_string + "\n"
	error_file = open('error_log', 'a')		# File: Error logging
	error_file.write(write_string)
	error_file.close()

def write_state(in_string):
	if in_string == "BrickPi3":
		in_string = "BrickPi"
	elif in_string == "BrickPi+":
		in_string = "BrickPi"

	error_file = open('selected_state', 'w')		# File: selected state
	error_file.write(in_string)
	error_file.close()

def read_state():
	error_file = open('selected_state', 'r')		# File: selected state
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
	
def kill_all_open_processes():
	p = subprocess.Popen(['ps', '-aux'], stdout=subprocess.PIPE)
	out, err = p.communicate()
	# print out
	for line in out.splitlines():
		if 'squeak' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)		
		if 'squeakvm' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)			
		if 'GoPiGoScratch' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)
			
		if 'GrovePiScratch' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)
			
		if 'BrickPi3Scratch' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)	
		if 'BrickPiScratch' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)	
		if 'PivotPiScratch' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)	


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
 
		
		#-------------------------------------------------------------------
		# Standard Buttons

		# Start Programming
		start_programming = wx.Button(self, label="Start Programming!", pos=(25,75))
		start_programming.Bind(wx.EVT_BUTTON, self.start_programming)
		
		# Exit
		exit_button = wx.Button(self, label="Exit", pos=(25,125))
		exit_button.Bind(wx.EVT_BUTTON, self.onClose)
	

		# End Standard Buttons		
		#-------------------------------------------------------------------
		# Drop Boxes

		controls = ['GoPiGo', 'GrovePi', 'BrickPi', 'PivotPi']	# Options for drop down.

		# Select Platform.
		
		robotDrop = wx.ComboBox(self, -1, read_state(), pos=(25, 25), size=(150, -1), choices=controls, style=wx.CB_READONLY)  # Drop down setup
		robotDrop.Bind(wx.EVT_COMBOBOX, self.robotDrop)					# Binds drop down.		
		wx.StaticText(self, -1, "Select a Robot:", (25, 5))					# (Minus 50, minus 0)
		
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
		send_bash_command_in_background("clear")	# This clears out the GTK Error Messages and warnings.
		dc = evt.GetDC()
 
		if not dc:
			dc = wx.ClientDC(self)
			rect = self.GetUpdateRegion().GetBox()
			dc.SetClippingRect(rect)
		dc.Clear()	
		bmp = wx.Bitmap(SCRATCH_PATH+"dex.png")	# Draw the photograph.
		dc.DrawBitmap(bmp, 0, 400)						# Absolute position of where to put the picture
		
		# Add a second picture.
		robot = SCRATCH_PATH+read_state()+".png"
		bmp = wx.Bitmap(robot)	# Draw the photograph.
		dc.DrawBitmap(bmp, 200, 0)	

		
		
	def robotDrop(self, event):
		write_debug("robotDrop Selected.")
		controls = ['GoPiGo', 'GrovePi', 'BrickPi', 'PivotPi']	# Options for drop down.
		value = event.GetSelection()
		print controls[value]
		# position = 0					# Position in the key list on file
		write_state(controls[value]) 	# print value to file.  
		
		# Update Picture
		robot = SCRATCH_PATH+read_state()+".png"
		png = wx.Image(robot, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
		wx.StaticBitmap(self, -1, png, (200, 0), (png.GetWidth(), png.GetHeight()))

	def start_programming(self, event):
		# Kill all Python Programs.  Any running *Scratch* Python Programs.
		write_debug("Start robot.")	
		dlg = wx.MessageDialog(self, 'This will close any open Scratch programs.  Please save your work and click Ok!', 'Alert!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
		ran_dialog = False
		if dlg.ShowModal() == wx.ID_OK:
			kill_all_open_processes()  # Kills all open squeak, Scratch programs.
		
			folder = read_state()
			if folder == 'BrickPi':
				if detected_robot == "BrickPi+":
					program = "/home/pi/Dexter/BrickPi+/Software/BrickPi_Scratch/BrickPiScratch.py"
				elif detected_robot == "BrickPi3":
					program = "/home/pi/Dexter/BrickPi3/Software/Scratch/BrickPi3Scratch.py"

			if folder == 'GoPiGo':
				program = "/home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGoScratch.py"
			if folder == 'GrovePi':
				program = "/home/pi/Desktop/GrovePi/Software/Scratch/GrovePiScratch.py"
			if folder == 'PivotPi':
				program = "/home/pi/Dexter/PivotPi/Software/Scratch/PivotPiScratch.py"
			start_command = "sudo python "+program
			send_bash_command_in_background(start_command)
		
			write_debug("Programming Started.")	
		
			file_temp = open(SCRATCH_PATH+"open_scratch.tmp", "w")
			file_temp.close()

			dlg.Destroy()
			self.frame.Close()
			sys.exit()				# Exit!
		else:
			print "Cancel Scratch Start!"
			dlg.Destroy()	
		dlt.Destroy()

		# Start Scratch
		''' 
		start_command = "scratch /home/pi/Desktop/GoBox/Scratch_GUI/new.sb"
		send_bash_command_in_background(start_command)
		dlg = wx.MessageDialog(self, 'Starting Scratch Programming!', 'Update', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		'''
		
		
	def onClose(self, event):	# Close the entire program.
		write_debug("Close Pressed.")
		kill_all_open_processes()  # Kills all open squeak, Scratch programs.
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

		wx.Icon(SCRATCH_PATH+'favicon.ico', wx.BITMAP_TYPE_ICO)
		wx.Log.SetVerbose(False)
		wx.Frame.__init__(self, None, title="Scratch for Robots", size=(400,300))		# Set the frame size

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
	#write_state("GoPiGo")

	# autodetect robot and pick the first one
	detected_robot = autodetect().split("_")[0]
	print detected_robot
	if detected_robot == "None":
		write_state("GoPiGo")
	if detected_robot == "BrickPi3" or detected_robot == "BrickPi+":
		write_state("BrickPi")
	else:
		write_state(detected_robot)
	kill_all_open_processes()  # Kills all open squeak, Scratch programs.

	# reset_file()	#Reset the file every time we turn this program on.
	app = Main()
	app.MainLoop()

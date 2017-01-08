import time
import wx
import os
import pickle
from datetime import datetime
import subprocess
from collections import Counter
import threading
import psutil
import signal
import urllib2
from gopigo import *

# References
# http://www.blog.pythonlibrary.org/2010/03/18/wxpython-putting-a-background-image-on-a-panel/
# ComboBoxes!  		http://wiki.wxpython.org/AnotherTutorial#wx.ComboBox
# 

HOME="/home/pi"
DEXTER="Dexter"
SCRATCH="Scratch_GUI"
s = "/";
seq = (HOME, DEXTER,"lib",DEXTER,SCRATCH) # This is sequence of strings.
SCRATCH_PATH = s.join( seq )+"/"

# Writes debug to file "error_log"
def write_debug(in_string):
	# In in time logging.
	#print in_string
	write_string = str(datetime.now()) + " - " + in_string + "\n"
	try:
		error_file = open(SCRATCH_PATH+'error_log', 'a')		# File: Error logging
		error_file.write(write_string)
		error_file.close()
	except:
		print " "

def write_state(in_string):
	error_file = open(SCRATCH_PATH+'selected_state', 'w')		# File: selected state
	error_file.write(in_string)
	error_file.close()

def read_state():
	error_file = open(SCRATCH_PATH+'selected_state', 'r')		# File: selected state
	in_string = ""
	in_string = error_file.read()
	error_file.close()
	if len(in_string):
		return in_string
	else:
		return 'GoPiGo'
	
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

def internet_on():
	try:
		response=urllib2.urlopen('http://www.raspberrypi.org', timeout=100)
		return True
	except urllib2.URLError as err: pass
	return False

	
def kill_all_open_processes():
	# p = subprocess.Popen(['ps', '-aux'], stdout=subprocess.PIPE)	# This line threw a BSD related warning.  Suppressed warning removing the "-"
	p = subprocess.Popen(['ps', 'aux'], stdout=subprocess.PIPE)
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
			
		if 'BrickPiScratch' in line:
			print line
			pid = int(line.split(None, 2)[1])
			kill_line = "sudo kill " + str(pid)
			send_bash_command(kill_line)	
			
		if 'PivotPi' in line:
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
		
		# font = wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, False, u'Consolas')
		font = wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, False, u'Helvetica')
		self.SetFont(font)
		
		#-------------------------------------------------------------------
		# Standard Buttons

		# Start Programming
		start_programming = wx.Button(self, label="Start Programming", pos=(25,275))
		start_programming.Bind(wx.EVT_BUTTON, self.start_programming)
		
		# Open Examples
		examples_button = wx.Button(self, label="Open Examples", pos=(25, 325))
		examples_button.Bind(wx.EVT_BUTTON, self.examples)			
		
		# Update Curriculum
		curriculum_update = wx.Button(self, label="Update GoBox", pos=(25,375))
		curriculum_update.Bind(wx.EVT_BUTTON, self.curriculum_update)

		# About
		about_button = wx.Button(self, label="About", pos=(25, 425))
		about_button.Bind(wx.EVT_BUTTON, self.About)
		
		# Test Hardware
		test_button = wx.Button(self, label="Demo Hardware", pos=(225, 425))
		test_button.Bind(wx.EVT_BUTTON, self.test)
		
		# Bind Stop Button 
		stop_gopigo = wx.Button(self, label="Stop GoPiGo", pos=(225,475))
		stop_gopigo.SetBackgroundColour('red')
		stop_gopigo.Bind(wx.EVT_BUTTON, self.stop_gopigo)
		
		# Exit
		exit_button = wx.Button(self, label="Exit", pos=(25,475))
		exit_button.Bind(wx.EVT_BUTTON, self.onClose)

		# End Standard Buttons		
		#-------------------------------------------------------------------
		# Drop Boxes

		controls = ['GoPiGo', 'GrovePi', 'BrickPi', 'PivotPi','Just Scratch, no Robot.']	# Options for drop down.

		# Select Platform.
		
		state = read_state()
		if state in controls:
			robotDrop = wx.ComboBox(self, -1, str(state), pos=(25, 225), size=(150, -1), choices=controls, style=wx.CB_READONLY)  # Drop down setup
		else:
			write_state("GoPiGo")
			robotDrop = wx.ComboBox(self, -1, "GoPiGo", pos=(25, 225), size=(150, -1), choices=controls, style=wx.CB_READONLY)  # Drop down setup
		robotDrop.Bind(wx.EVT_COMBOBOX, self.robotDrop)					# Binds drop down.		
		
		wx.StaticText(self, -1, "Select a Robot:", (25, 205))					# (Minus 50, minus 0)
		
		# wx.StaticText(self, -1, "Caution: Do not close the LXTerminal window running \nin the background right now.", (25, 520))
		wx.StaticText(self, -1, "Caution: Do not close the Scratch Controller window \nrunning in the background right now.", (25, 520))

		# Drop Boxes
		#-------------------------------------------------------------------
		
		hSizer.Add((1,1), 1, wx.EXPAND)
		hSizer.Add(sizer, 0, wx.TOP, 100)
		hSizer.Add((1,1), 0, wx.ALL, 75)
		self.SetSizer(hSizer)
	
		self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)		# Sets background picture
 		send_bash_command_in_background("clear")	# This clears out the GTK Error Messages and warnings.
 		
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
		bmp = wx.Bitmap(SCRATCH_PATH+"dex.png")	# Draw the photograph.
		dc.DrawBitmap(bmp, 0, 0)						# Absolute position of where to put the picture
		
		# Add a second picture.
		if read_state() == 'Just Scratch, no Robot.':
			print "Selected Just Scratch no Robot."
		else:
			robot = SCRATCH_PATH+read_state()+".png"
			bmp = wx.Bitmap(robot)	# Draw the photograph.
			dc.DrawBitmap(bmp, 200, 200)	

	def robotDrop(self, event):
		write_debug("robotDrop Selected.")
		controls = ['GoPiGo', 'GrovePi', 'BrickPi', 'PivotPi', 'Just Scratch, no Robot.']	# Options for drop down.
		value = event.GetSelection()
		print controls[value]
		# position = 0				# Position in the key list on file
		
		write_state(controls[value])    # print value to file.  
		if(controls[value]=='Just Scratch, no Robot.'):
			print "Just Scratch!"
			# robot = "/home/pi/Desktop/GoBox/Scratch_GUI/"+read_state()+".png"
			# png = wx.Image(robot, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
			# wx.StaticBitmap(self, -1, png, (200, 200), (png.GetWidth(), png.GetHeight()))

		else:
			write_state(controls[value]) 	# print value to file.  
		
			# Update Picture
			try:
				print "Read State: " + str(read_state())
				robot = SCRATCH_PATH+read_state()+".png"
				png = wx.Image(robot, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
				wx.StaticBitmap(self, -1, png, (200, 200), (png.GetWidth(), png.GetHeight()))
			except:
				print "Failed robotDrop."

			

	def stop_gopigo(self, event):
		write_debug("STOP robot.")
		stop()

	def start_programming(self, event):
		# Kill all Python Programs.  Any running *Scratch* Python Programs.
		write_debug("Start robot.")	
		dlg = wx.MessageDialog(self, 'This will close any open Scratch programs.  Please save and click Ok!', 'Alert!', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()

		kill_all_open_processes()

		folder = read_state()
		if folder.find('BrickPi') >= 0:
			program = "/home/pi/Dexter/BrickPi+/BrickPi/Software/BrickPi_Scratch/BrickPiScratch.py"
		elif folder.find('GoPiGo') >= 0:
			program = "/home/pi/Dexter/GoPiGo/Software/Scratch/GoPiGoScratch.py"
		elif folder.find('PivotPi') >= 0:
			program = "/home/pi/Dexter/PivotPi/Software/Scratch/PivotPiScratch.py"
		else:
			program = "/home/pi/Dexter/GrovePi/Software/Scratch/GrovePiScratch.py"
		start_command = "sudo python "+program
		send_bash_command_in_background(start_command)
		
		write_debug("Programming Started.")	
		
		# Start Scratch
		start_command = "bash {0}scratch_direct {0}new.sb".format(SCRATCH_PATH)
		send_bash_command_in_background(start_command)
		'''
		dlg = wx.MessageDialog(self, 'Starting Scratch Programming!', 'Update', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		'''

	def curriculum_update(self, event):
		write_debug("Update pressed.")
		# app = wx.PySimpleApp()
		progressMax = 100
		if internet_on():
			dlg = wx.ProgressDialog("Update GoBox", "Remaining", progressMax,style=wx.PD_ELAPSED_TIME | wx.PD_REMAINING_TIME)
			print(os.path.isdir("/home/pi/Desktop/GoBox/"))
			dlg.Update(25)
			if(os.path.isdir("/home/pi/Desktop/GoBox")):
				dlg.Update(35)
				os.chdir("/home/pi/Desktop/GoBox")
				send_bash_command("sudo git fetch origin")
				dlg.Update(55)
				send_bash_command("sudo git reset --hard")
				dlg.Update(65)
				send_bash_command("sudo git merge origin/master")
				dlg.Update(75)
			else:
				os.chdir("/home/pi/Desktop/") 											# Change directory.
				dlg.Update(25)
				send_bash_command("sudo git clone https://github.com/DexterInd/GoBox")	# Clone the repo.
				dlg.Update(35)
			print "End of Dialog Box!"
		
			# Check Permissions of Scratch, Update them.
			print "Install Scratch Shortcuts and Permissions."
			send_bash_command("sudo rm /home/pi/Desktop/Scratch_Start.desktop")  					# Delete old icons off desktop
			send_bash_command("sudo cp {}Scratch_Start.desktop /home/pi/Desktop".format(SCRATCH_PATH))	# Move icons to desktop
			send_bash_command("sudo chmod +x /home/pi/Desktop/Scratch_Start.desktop")
			send_bash_command("sudo chmod +x /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGoScratch_debug.sh")					# Change script permissions
			send_bash_command("sudo chmod +x /home/pi/Desktop/GoPiGo/Software/Scratch/GoPiGo_Scratch_Scripts/GoPiGo_Scratch_Start.sh")					# Change script permissions
			send_bash_command("sudo chmod +x {}click_scratch.py".format(SCRATCH_PATH))
			send_bash_command("sudo chmod +x {}scratch".format(SCRATCH_PATH))
			send_bash_command("sudo chmod ugo+r {}new.sb".format(SCRATCH_PATH))
			send_bash_command("sudo chmod ugo+r {}new.sb.bkp".format(SCRATCH_PATH))
			send_bash_command("sudo chmod +x {}Scratch_Start.sh".format(SCRATCH_PATH))
			send_bash_command("sudo chmod 777 {}selected_state".format(SCRATCH_PATH))
			send_bash_command("sudo chmod 777 {}error_log".format(SCRATCH_PATH))
			send_bash_command("sudo chmod 777 /home/pi/nohup.out")
			time.sleep(1)
			print "File permissions changed."
			
			dlg.Destroy()
		else:
			dlg = wx.MessageDialog(self, 'Internet not detected!  Please connect to the internet and try again!', 'Update', wx.OK|wx.ICON_INFORMATION)
			dlg.ShowModal()
			write_debug("Internet out.  Not connected.")
			dlg.Destroy()

	def examples(self, event):
		write_debug("Examples Pressed.")	
		folder = read_state()
		if(folder == "GoPiGo"):
			directory = "nohup pcmanfm /home/pi/Desktop/GoPiGo/Software/Scratch/Examples/"
		if(folder == "GrovePi"):
                        directory = "nohup pcmanfm /home/pi/Desktop/GrovePi/Software/Scratch/Grove_Examples/"
		if(folder == "BrickPi"):
			directory = "nohup pcmanfm /home/pi/Desktop/BrickPi_Scratch/Examples/"

		send_bash_command_in_background(directory)
		print "Opened up file manager!"
		write_debug("Opened up file manager!")

	def test(self, event):
		# Test the hardware.  Test the selected hardware.  
		write_debug("Demo robot.")
		folder = read_state()
		if folder.find('BrickPi') >= 0:
			# Run BrickPi Test.
			dlg = wx.MessageDialog(self, 'Ok, start BrickPi Test. Make sure the BrickPi is powered by batteries, a motor is connected, and a touch sensor is connected to Port 1.  You shold see the LEDs blink and the motors move when the touch sensor is pressed.  Then press Ok. ', 'Test BrickPi!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
			ran_dialog = False
			if dlg.ShowModal() == wx.ID_OK:
				print "Run Hardware Test!"
				program = "sudo python /home/pi/Dexter/BrickPi+/Software/BrickPi_Python/Sensor_Examples/Brick_Hardware_Test.py"
				send_bash_command_in_background(program)
				ran_dialog = True
			else:
				print "Canceled!"
			dlg.Destroy()
			
			# Depending on what the user chose, we either cancel or complete.  
			if ran_dialog:
				dlg = wx.MessageDialog(self, 'Test Complete.', 'Complete', wx.OK|wx.ICON_INFORMATION)
				dlg.ShowModal()
				dlg.Destroy()
			else:
				dlg = wx.MessageDialog(self, 'Test Canceled.', 'Canceled', wx.OK|wx.ICON_HAND)
				dlg.ShowModal()
				dlg.Destroy()

		elif folder.find('GoPiGo') >= 0:
			# Run GoPiGo Test.
			dlg = wx.MessageDialog(self, 'This Demo program will make sure everything is working on your GoPiGo.  The red LEDs in the front of the GoPiGo will blink once, and the GoPiGo will move forward, and then backwards.  So make sure it is on the floor so it does not fall off the table! \n\nMake sure your batteries are connected to the GoPiGo, motors are connected, and it is turned on.  Be sure to unplug the power supply wall adapter from the GoPiGo. It is best to be working through wifi, but if the GoPiGo is connected to your computer with a cable right now, turn it upside down for the demo.  \n\nClick OK to begin.', 'Demonstrate the GoPiGo', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
			ran_dialog = False
			if dlg.ShowModal() == wx.ID_OK:
				print "Begin Running GoPiGo Test!"
				program = "sudo python /home/pi/Dexter/GoPiGo/Software/Python/hardware_test_2.py"
				send_bash_command_in_background(program)
				ran_dialog = True
			else:
				print "Canceled!"
			dlg.Destroy()
			
			# Depending on what the user chose, we either cancel or complete.  
			if ran_dialog:
				dlg = wx.MessageDialog(self, 'Demo Complete', 'Complete', wx.OK|wx.ICON_INFORMATION)
				dlg.ShowModal()
				dlg.Destroy()
			else:
				dlg = wx.MessageDialog(self, 'Demo Canceled', 'Canceled', wx.OK|wx.ICON_HAND)
				dlg.ShowModal()
				dlg.Destroy()
				
		else:
			# Run GrovePi Test.
			dlg = wx.MessageDialog(self, 'Ok, start GrovePi Test. Attach buzzer to D8 and a button to A0.  Press the button and the buzzer should sound.  Press Ok to start. ', 'Test GrovePi!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
			ran_dialog = False
			if dlg.ShowModal() == wx.ID_OK:
				print "Run GrovePi Test!"
				program = "sudo python /home/pi/Dexter/GrovePi/Software/Python/GrovePi_Hardware_Test.py"
				send_bash_command_in_background(program)
				ran_dialog = True
			else:
				print "Canceled!"
			dlg.Destroy()
			
			# Depending on what the user chose, we either cancel or complete.  
			if ran_dialog:
				dlg = wx.MessageDialog(self, 'Test Complete', 'Complete', wx.OK|wx.ICON_INFORMATION)
				dlg.ShowModal()
				dlg.Destroy()
			else:
				dlg = wx.MessageDialog(self, 'Test Canceled', 'Canceled', wx.OK|wx.ICON_HAND)
				dlg.ShowModal()
				dlg.Destroy()
				
	def About(self, event):
		write_debug("About Pressed.")	
		dlg = wx.MessageDialog(self, 'Learn more about Dexter Industries and GoBox at dexterindustries.com', 'About', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		
	def onClose(self, event):	# Close the entire program.
		#write_state('GoPiGo')
		write_debug("Close Pressed.")
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
		wx.Frame.__init__(self, None, title="Scratch for Robots", size=(400,600))		# Set the fram size

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
	write_debug(" # Program # started # !")
	#write_state("GoPiGo")
	kill_all_open_processes()
	# reset_file()	#Reset the file every time we turn this program on.
	app = Main()
	app.MainLoop()

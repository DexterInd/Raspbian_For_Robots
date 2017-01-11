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
		
def send_bash_command(bashCommand):
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE) #, stderr=subprocess.PIPE)
	output = process.communicate()[0]
	return output

def send_bash_command_output(bashCommand):
	# print bashCommand
	# write_debug(bashCommand)
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE) #, stderr=subprocess.PIPE)
	# print process
	output = process.communicate()[0]
	# print output
	return output

def send_bash_command_in_background(bashCommand):
	# Fire off a bash command and forget about it.
	# write_debug(bashCommand)
	process = subprocess.Popen(bashCommand.split())

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
		
		font = wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, False, u'Helvetica')
		self.SetFont(font)
		
		#-------------------------------------------------------------------
		# Standard Buttons
		y=200
		# Troubleshoot the GoPiGo
		troubleshoot_gopigo = wx.Button(self, label="Troubleshoot GoPiGo", pos=(25,y))
		troubleshoot_gopigo.Bind(wx.EVT_BUTTON, self.troubleshoot_gopigo)
		wx.StaticText(self, -1, "This button runs a series of tests on the GoPiGo Hardware.", (175, y))
		
		# Troubleshoot the GrovePi
		troubleshoot_grovepi = wx.Button(self, label="Troubleshoot GrovePi", pos=(25, y+75))
		troubleshoot_grovepi.Bind(wx.EVT_BUTTON, self.grovepi)			
		wx.StaticText(self, -1, "This button runs a series of tests on the GrovePi Hardware.", (175, y+75))
		
		# Demo the GoPiGo
		demo_gopigo = wx.Button(self, label="Demo GoPiGo", pos=(25,y+150))
		demo_gopigo.Bind(wx.EVT_BUTTON, self.demo_gopigo)
		wx.StaticText(self, -1, "This button demonstrates the GoPiGo Hardware.", (175, y+150))

		# Exit
		exit_button = wx.Button(self, label="Exit", pos=(25,y+225))
		exit_button.Bind(wx.EVT_BUTTON, self.onClose)
		
		wx.StaticText(self, -1, "Caution: Do not close the LXTerminal window running in the background right now.", (25, y+275))
		
		
		
		self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)		# Sets background picture
 
	#----------------------------------------------------------------------
	def OnEraseBackground(self, evt):

		dc = evt.GetDC()
 
		if not dc:
			dc = wx.ClientDC(self)
			rect = self.GetUpdateRegion().GetBox()
			dc.SetClippingRect(rect)
		dc.Clear()	
		bmp = wx.Bitmap("/home/pi/Desktop/GoBox/Troubleshooting_GUI/dex.png")	# Draw the photograph.
		dc.DrawBitmap(bmp, 10, 10)						# Absolute position of where to put the picture

	###############################################################################
	def troubleshoot_gopigo(self, event):
		dlg = wx.MessageDialog(self, 'This program tests the GoPiGo for potential issues or problems and will make a log report you can send to Dexter Industries.  \n 1. Make sure the battery pack is connected to the GoPiGo and turn it on.  \n 2. Turn the GoPiGo upside down so the wheels are in the air for the test.  \n 3. Then click OK to begin the test.  \n It takes a few moments for the test to start, and once it has begun, it might take a few minutes to run through all the tests.', 'Troubleshoot the GoPiGo', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
		
		ran_dialog = False
		if dlg.ShowModal() == wx.ID_OK:
			print "Start GoPiGo Test!"
			send_bash_command('sudo chmod +x /home/pi/Desktop/GoPiGo/Troubleshooting/all_tests.sh')
			send_bash_command('sudo /home/pi/Desktop/GoPiGo/Troubleshooting/all_tests.sh')
			ran_dialog = True
		else:
			print "Cancel GoPiGo Test!"
		dlg.Destroy()
		
		# Depending on what the user chose, we either cancel or complete.  
		if ran_dialog:
			dlg = wx.MessageDialog(self, 'All tests are complete. The Log has been saved to Desktop. Please copy it and upload it into our Forums.  www.dexterindustries.com/Forum ', 'Complete', wx.OK|wx.ICON_INFORMATION)
			dlg.ShowModal()
			dlg.Destroy()
		else:
			dlg = wx.MessageDialog(self, 'Troubleshoot GoPiGo Canceled', 'Canceled', wx.OK|wx.ICON_HAND)
			dlg.ShowModal()
			dlg.Destroy()

	###############################################################################
	def demo_gopigo(self, event):
		dlg = wx.MessageDialog(self, 'This Demo program will make sure everything is working on your GoPiGo.  The red LEDs in the front of the GoPiGo will blink once, and the GoPiGo will move forward, and then backwards.  So make sure it is on the floor so it does not fall off the table! \n\nMake sure your batteries are connected to the GoPiGo, motors are connected, and it is turned on.  Be sure to unplug the power supply wall adapter from the GoPiGo. It is best to be working through wifi, but if the GoPiGo is connected to your computer with a cable right now, turn it upside down for the demo.  \n\nClick OK to begin.', 'Demonstrate the GoPiGo', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
		ran_dialog = False
		if dlg.ShowModal() == wx.ID_OK:
			print "Start GoPiGo Demo!"
			# send_bash_command('sudo python /home/pi/Desktop/GoPiGo/Software/Python/other_scripts/demo.py')
			program = "sudo python /home/pi/Desktop/GoPiGo/Software/Python/hardware_test_2.py"
			send_bash_command_in_background(program)
			ran_dialog = True
		else:
			print "Cancel GoPiGo Demo!"
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
			
	###############################################################################
	def grovepi(self, event):
		dlg = wx.MessageDialog(self, 'This program tests the GrovePi for potential issues or problems and will make a log report you can send to Dexter Industries.  \n It takes a few moments for the test to start, and once it has begun, it might take a few minutes to run through all the tests.', 'Troubleshoot the GrovePi', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
		ran_dialog = False
		if dlg.ShowModal() == wx.ID_OK:
			print "Running GrovePi Tests!"
			send_bash_command('sudo chmod +x /home/pi/Desktop/GrovePi/Troubleshooting/all_tests.sh')
			send_bash_command('sudo /home/pi/Desktop/GrovePi/Troubleshooting/all_tests.sh')
			ran_dialog = True
		else:
			print "Cancel GrovePi Tests!"
		dlg.Destroy()
		
		# Depending on what the user chose, we either cancel or complete.  
		if ran_dialog:
			dlg = wx.MessageDialog(self, 'All tests are complete. The Log has been saved to Desktop. Please copy it and upload it into our Forums.  www.dexterindustries.com/Forum', 'OK', wx.OK|wx.ICON_INFORMATION)
			dlg.ShowModal()
			dlg.Destroy()
		else:
			dlg = wx.MessageDialog(self, 'GrovePi Test Canceled', 'Canceled', wx.OK|wx.ICON_HAND)
			dlg.ShowModal()
			dlg.Destroy()

	def onClose(self, event):	# Close the entire program.
		self.frame.Close()
  
########################################################################
class MainFrame(wx.Frame):
	#----------------------------------------------------------------------
	def __init__(self):
		"""Constructor"""
		# wx.ComboBox

		wx.Icon('/home/pi/Desktop/GoBox/Troubleshooting_GUI/favicon.ico', wx.BITMAP_TYPE_ICO)
		wx.Log.SetVerbose(False)
		wx.Frame.__init__(self, None, title="Test and Troubleshoot Dexter Industries Hardware", size=(500,500))		# Set the fram size

		panel = MainPanel(self)        
		self.Center()
		
########################################################################
class Main(wx.App):
    #----------------------------------------------------------------------
    def __init__(self, redirect=False, filename=None):
        """Constructor"""
        wx.App.__init__(self, redirect, filename)
        dlg = MainFrame()
        dlg.Show()
		
if __name__ == "__main__":
	app = Main()
	app.MainLoop()

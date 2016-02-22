#!/usr/bin/python
# This program is the GUI for backup functions.
# The program files called can be found in ~/di_update/Raspbian_for_Robots/backup
# This program is used to backup and restor files to a USB drive.

try:
	import wx
except ImportError:
	raise ImportError, "The wxPython module is required to run this program."
	
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

'''

# Writes debug to file "error_log"
def write_debug(in_string):
	# In in time logging.
	#print in_string
	write_string = str(datetime.now()) + " - " + in_string + "\n"
	error_file = open('/home/pi/backup_error_log', 'w+')		# File: Error logging
	error_file.write(write_string)
	error_file.close()
	
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
 
		wx.StaticText(self, -1, "Raspbian For Robots Backup", (25, 5))					# (Minus 50, minus 0)
 		wx.StaticText(self, -1, "Insert a USB drive into the Raspberry Pi.", (25, 25))					# (Minus 50, minus 0)

		#-------------------------------------------------------------------
		# Standard Buttons

		# Upate Raspbian
		backup = wx.Button(self, label="Backup Your Files", pos=(25,50))
		backup.Bind(wx.EVT_BUTTON, self.backup)
		
		# Update DI Software
		restore = wx.Button(self, label="Restore Your Files", pos=(25, 100))
		restore.Bind(wx.EVT_BUTTON, self.restore)			

		# Exit
		exit_button = wx.Button(self, label="Exit", pos=(25,150))
		exit_button.Bind(wx.EVT_BUTTON, self.onClose)
	
		# End Standard Buttons		
		
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

		robot = "/home/pi/di_update/Raspbian_For_Robots/update_gui_elements/dex.png"
		bmp = wx.Bitmap(robot)	# Draw the photograph.
		dc.DrawBitmap(bmp, 225, 15)
		
	# Update the Operating System.
	def backup(self, event):
		write_debug("backup")
		dlg = wx.MessageDialog(self, 'Backup will start!  Be sure that your USB drive is in place on the Raspberry Pi.', 'Alert!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
		ran_dialog = False
		if dlg.ShowModal() == wx.ID_OK:
			start_command = "sudo sh /home/pi/di_update/Raspbian_For_Robots/backup/call_backup.sh"
			send_bash_command_in_background(start_command)
			print "Start Backup!"
			ran_dialog = True
		else:
			print "Cancel backup!"
		dlg.Destroy()
		
		write_debug("Cancel backup!")

	# Restore the Software.
	def restore(self, event):
		write_debug("Restore from a backup.")	
		dlg = wx.MessageDialog(self, 'Restore will start.  This will create a directory on the Desktop with the backup files on the USB device in the Raspberry Pi.', 'Alert!', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
		
		ran_dialog = False
		if dlg.ShowModal() == wx.ID_OK:
			start_command = "sudo sh /home/pi/di_update/Raspbian_For_Robots/backup/call_restore.sh"
			send_bash_command_in_background(start_command)
			print "Restore from a backup.!"
			ran_dialog = True
		else:
			print "Cancel Restore from a backup.!"
		dlg.Destroy()
		
		write_debug("Restore from a backup. Finished.")
		
	def onClose(self, event):	# Close the entire program.
		write_debug("Close Pressed.")
		self.frame.Close()
  
########################################################################
class MainFrame(wx.Frame):
	""""""
	
	#----------------------------------------------------------------------
	def __init__(self):
		"""Constructor"""

		wx.Log.SetVerbose(False)
		wx.Frame.__init__(self, None, title="Run File Backup", size=(400,250))		# Set the frame size

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

	app = Main()
	app.MainLoop()

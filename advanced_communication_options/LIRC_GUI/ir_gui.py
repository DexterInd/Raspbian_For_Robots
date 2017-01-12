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
import ir_receiver_check

def send_bash_command(bashCommand):
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE) #, stderr=subprocess.PIPE)
	output = process.communicate()[0]
	return output
	
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
		y=20
		# Enable IR Receiver
		enable_ir_receiver = wx.Button(self, label="Enable IR receiver", pos=(25,y))
		enable_ir_receiver.Bind(wx.EVT_BUTTON, self.enable_ir_receiver)
		
		# Disable IR Receiver
		disable_ir_receiver = wx.Button(self, label="Disable IR receiver", pos=(25, y+50))
		disable_ir_receiver.Bind(wx.EVT_BUTTON, self.dis_ir_rec)			
		 
		#Update Curriculum
		test_ir_receiver = wx.Button(self, label="Test IR receiver", pos=(25,y+100))
		test_ir_receiver.Bind(wx.EVT_BUTTON, self.test_ir_receiver)
		
		''' 
		# Reboot
		# reboot_button = wx.Button(self, label="Reboot", pos=(25,y+150))
		# reboot_button.Bind(wx.EVT_BUTTON, self.reboot)
		'''
		
		# Exit
		exit_button = wx.Button(self, label="Exit", pos=(25,y+200))
		exit_button.Bind(wx.EVT_BUTTON, self.onClose) 
		 
		wx.StaticText(self, -1, "Caution: Do not close the terminal window!", (25, y+250))
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
		dc.DrawBitmap(bmp, 200, 60)						# Absolute position of where to put the picture

	def enable_ir_receiver(self, event):
		dlg = wx.MessageDialog(self, 'Enabling IR Receiver', 'Enable IR Receiver', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		
		ir_receiver_check.enable_ir()
		
		dlg = wx.MessageDialog(self, 'IR receiver enabled. Please reboot', 'Reboot', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()

	def test_ir_receiver(self, event):
		dlg = wx.MessageDialog(self, 'Click OK to begin testing IR receiver.', 'Begin Check', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()

		check=ir_receiver_check.check_ir()
		# send_bash_command('sudo python /home/pi/Desktop/GoPiGo/Software/Python/other_scripts/demo.py')
		if check:
			dlg = wx.MessageDialog(self, 'IR receiver is enabled', 'Enable', wx.OK|wx.ICON_INFORMATION)
		else:
			dlg = wx.MessageDialog(self, 'IR receiver is disabled', 'Disable', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		
	def dis_ir_rec(self, event):
		dlg = wx.MessageDialog(self, 'Disabling IR receiver', 'Disable', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
	
		ir_receiver_check.disable_ir()
		
		dlg = wx.MessageDialog(self, 'IR receiver disabled. Please reboot', 'Disabled', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		
	'''def reboot(self,event):
		dlg = wx.MessageDialog(self, 'Rebooting', 'Rebooting', wx.OK|wx.ICON_INFORMATION)
		dlg.ShowModal()
		dlg.Destroy()
		send_bash_command('sudo reboot')
	'''
		
	def onClose(self, event):	# Close the entire program.
		dlg = wx.MessageDialog(self, 'You must reboot for changes to take effect.  Reboot now?', 'Reboot', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
		if dlg.ShowModal() == wx.ID_OK:
			# Reboot
			send_bash_command('sudo reboot')
		else: 
			# Do nothing.
			print "No reboot."
		dlg.Destroy()
		self.frame.Close()
  
########################################################################
class MainFrame(wx.Frame):
	#----------------------------------------------------------------------
	def __init__(self):
		"""Constructor"""
		# wx.ComboBox

		wx.Icon('/home/pi/Desktop/GoBox/Troubleshooting_GUI/favicon.ico', wx.BITMAP_TYPE_ICO)
		wx.Log.SetVerbose(False)
		wx.Frame.__init__(self, None, title="IR Receiver Setup", size=(600,300))		# Set the fram size

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

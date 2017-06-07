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
from auto_detect_robot import *


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
        self.SetBackgroundColour(wx.WHITE)
        self.frame = parent
        
        # detect what's currently on
        needed_robots=autodetect()
        
        # if you can't find a single robot
        # then show all of them just in case (except BrickPi+)
        if needed_robots.find("GoPiGo") == -1 and \
           needed_robots.find("GoPiGo3") == -1 and \
           needed_robots.find("GrovePi") == -1 and \
           needed_robots.find("BrickPi+") == -1 and \
           needed_robots.find("BrickPi3") == -1:
            needed_robots = "GoPiGo_GoPiGo3_GrovePi_BrickPi3"
        
        vSizer = wx.BoxSizer(wx.VERTICAL)
        
        font = wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, False,
                        u'Helvetica')
        self.SetFont(font)
        
        #-------------------------------------------------------------------
        # icon
        icon_sizer = wx.BoxSizer(wx.HORIZONTAL)
        bmp = wx.Bitmap(
            "/home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/dex.png",
            type=wx.BITMAP_TYPE_PNG)	# Draw the photograph.
        bitmap=wx.StaticBitmap(self,bitmap=bmp)
        bmpW,bmpH = bitmap.GetSize()
        icon_sizer.Add(bitmap,0,wx.RIGHT|wx.LEFT|wx.EXPAND,50)
        
        # Troubleshoot the GoPiGo
        # Need to find the string GoPiGo and NOT find the string "3"
        if needed_robots.find("GoPiGo")!=-1 and needed_robots.find("3") == -1:
            gopigo_sizer = wx.BoxSizer(wx.HORIZONTAL)
            troubleshoot_gopigo = wx.Button(self, label="Troubleshoot GoPiGo")
            troubleshoot_gopigo.Bind(wx.EVT_BUTTON, self.troubleshoot_gopigo)
            gopigo_txt=wx.StaticText(self, -1, "This button runs a series of tests on the GoPiGo Hardware.")
            gopigo_txt.Wrap(150)
            gopigo_sizer.AddSpacer(50)
            gopigo_sizer.Add(troubleshoot_gopigo,1,wx.EXPAND)
            gopigo_sizer.AddSpacer(20)
            gopigo_sizer.Add(gopigo_txt,1,wx.ALIGN_CENTER_VERTICAL)
            gopigo_sizer.AddSpacer(50)
        
        # Troubleshoot the GoPiGo3
        if needed_robots.find("GoPiGo3")!=-1:
            gopigo3_sizer = wx.BoxSizer(wx.HORIZONTAL)
            troubleshoot_gopigo3 = wx.Button(self, label="Troubleshoot GoPiGo3")
            troubleshoot_gopigo3.Bind(wx.EVT_BUTTON, self.gopigo3)
            gopigo3_txt=wx.StaticText(self, -1, "This button runs a series of tests on the GoPiGo3 Hardware.")
            gopigo3_txt.Wrap(150)
            gopigo3_sizer.AddSpacer(50)
            gopigo3_sizer.Add(troubleshoot_gopigo3,1,wx.EXPAND)
            gopigo3_sizer.AddSpacer(20)
            gopigo3_sizer.Add(gopigo3_txt,1,wx.ALIGN_CENTER_VERTICAL)
            gopigo3_sizer.AddSpacer(50)
        
        # Demo the GoPiGo3
        if needed_robots.find("GoPiGo3") != -1:
            gopigo3_demo_sizer=wx.BoxSizer(wx.HORIZONTAL)
            demo_gopigo3 = wx.Button(self, label="Demo GoPiGo3")
            demo_gopigo3.Bind(wx.EVT_BUTTON, self.demo_gopigo3)
            demo_gopigo3_txt=wx.StaticText(self, -1, "This button demonstrates the GoPiGo3 Hardware.")
            demo_gopigo3_txt.Wrap(150)
            gopigo3_demo_sizer.AddSpacer(50)
            gopigo3_demo_sizer.Add(demo_gopigo3,1,wx.EXPAND)
            gopigo3_demo_sizer.AddSpacer(20)
            gopigo3_demo_sizer.Add(demo_gopigo3_txt,1,wx.ALIGN_CENTER_VERTICAL)
            gopigo3_demo_sizer.AddSpacer(50)
        
        if needed_robots.find("GrovePi")!=-1:
            # Troubleshoot the GrovePi
            grovepi_sizer = wx.BoxSizer(wx.HORIZONTAL)
            troubleshoot_grovepi = wx.Button(self, label="Troubleshoot GrovePi")
            troubleshoot_grovepi.Bind(wx.EVT_BUTTON, self.grovepi)
            grovepi_txt=wx.StaticText(self, -1, "This button runs a series of tests on the GrovePi Hardware.")
            grovepi_txt.Wrap(150)
            grovepi_sizer.AddSpacer(50)
            grovepi_sizer.Add(troubleshoot_grovepi,1,wx.EXPAND)
            grovepi_sizer.AddSpacer(20)
            grovepi_sizer.Add(grovepi_txt,1,wx.ALIGN_CENTER_VERTICAL)
            grovepi_sizer.AddSpacer(50)
        
        #Troubleshoot the BrickPi3
        if needed_robots.find("BrickPi3")!=-1:
            brickpi3_sizer = wx.BoxSizer(wx.HORIZONTAL)
            troubleshoot_brickpi3 = wx.Button(self, label="Troubleshoot BrickPi3")
            troubleshoot_brickpi3.Bind(wx.EVT_BUTTON, self.brickpi3)
            brickpi3_txt=wx.StaticText(self, -1, "This button runs a series of tests on the BrickPi3 Hardware. (not BrickPi+)")
            brickpi3_txt.Wrap(150)
            brickpi3_sizer.AddSpacer(50)
            brickpi3_sizer.Add(troubleshoot_brickpi3,1,wx.EXPAND)
            brickpi3_sizer.AddSpacer(20)
            brickpi3_sizer.Add(brickpi3_txt,1,wx.ALIGN_CENTER_VERTICAL)
            brickpi3_sizer.AddSpacer(50)
        
        #Troubleshoot the BrickPi+ (or don't)
        if needed_robots.find("BrickPi+")!=-1:
            brickpiP_sizer = wx.BoxSizer(wx.HORIZONTAL)
            troubleshoot_brickpiP = wx.StaticText(self, label="BrickPi+ detected.")
            brickpiP_txt=wx.StaticText(self, -1, "There are no troubleshooting scripts for BrickPi+")
            brickpiP_txt.Wrap(150)
            brickpiP_sizer.AddSpacer(50)
            brickpiP_sizer.Add(troubleshoot_brickpiP,1,wx.EXPAND)
            brickpiP_sizer.AddSpacer(20)
            brickpiP_sizer.Add(brickpiP_txt,1,wx.ALIGN_CENTER_VERTICAL)
            brickpiP_sizer.AddSpacer(50)
         
        # Demo the GoPiGo
        if needed_robots.find("GoPiGo") != -1 and needed_robots.find("3") == -1:
            demo_sizer=wx.BoxSizer(wx.HORIZONTAL)
            demo_gopigo = wx.Button(self, label="Demo GoPiGo")
            demo_gopigo.Bind(wx.EVT_BUTTON, self.demo_gopigo)
            demo_gopigo_txt=wx.StaticText(self, -1, "This button demonstrates the GoPiGo Hardware.")
            demo_gopigo_txt.Wrap(150)
            demo_sizer.AddSpacer(50)
            demo_sizer.Add(demo_gopigo,1,wx.EXPAND)
            demo_sizer.AddSpacer(20)
            demo_sizer.Add(demo_gopigo_txt,1,wx.ALIGN_CENTER_VERTICAL)
            demo_sizer.AddSpacer(50)
        
        # Exit
        exit_sizer = wx.BoxSizer(wx.HORIZONTAL)
        exit_button = wx.Button(self, label="Exit")
        exit_button.Bind(wx.EVT_BUTTON, self.onClose)
        exit_sizer.AddSpacer(50)
        exit_sizer.Add(exit_button,1,wx.EXPAND)
        exit_sizer.AddSpacer(50)
        
        caution_sizer = wx.BoxSizer(wx.HORIZONTAL)
        caution_txt = wx.StaticText(self, -1, "Caution: Do not close the LXTerminal window running in the background right now.")
        caution_sizer.AddSpacer(50)
        caution_sizer.Add(caution_txt,1,wx.EXPAND)
        caution_sizer.AddSpacer(50)
        
        vSizer.Add(icon_sizer,0,wx.SHAPED|wx.FIXED_MINSIZE)
        if needed_robots.find("GoPiGo") != -1 and needed_robots.find("3") == -1:
            vSizer.Add(gopigo_sizer,1,wx.EXPAND)
            vSizer.AddSpacer(20)
        if needed_robots.find("GoPiGo3") != -1:
            vSizer.Add(gopigo3_sizer,1,wx.EXPAND)
            vSizer.AddSpacer(20)
        if needed_robots.find("GrovePi") != -1:
            vSizer.Add(grovepi_sizer,1,wx.EXPAND)
            vSizer.AddSpacer(20)
        if needed_robots.find("BrickPi3") != -1:
            vSizer.Add(brickpi3_sizer,1,wx.EXPAND)
            vSizer.AddSpacer(20)
        if needed_robots.find("BrickPi+") != -1:
            vSizer.Add(brickpiP_sizer,1,wx.EXPAND)
            vSizer.AddSpacer(20)
        if needed_robots.find("GoPiGo") != -1 and needed_robots.find("3") == -1:
            vSizer.Add(demo_sizer,1,wx.EXPAND)
            vSizer.AddSpacer(20)
        if needed_robots.find("GoPiGo3") != -1:
            vSizer.Add(gopigo3_demo_sizer,1,wx.EXPAND)
            vSizer.AddSpacer(20)
        
        vSizer.Add(exit_sizer,1,wx.EXPAND)
        vSizer.AddSpacer(20)
        vSizer.Add(caution_sizer,1,wx.EXPAND|wx.ALIGN_CENTER_VERTICAL)
        
        self.SetSizerAndFit(vSizer)
        # self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)		# Sets background picture
    
    #----------------------------------------------------------------------
    def OnEraseBackground(self, evt):
        
        dc = evt.GetDC()
        
        # if not dc:
        # 	dc = wx.ClientDC(self)
        # 	rect = self.GetUpdateRegion().GetBox()
        # 	dc.SetClippingRect(rect)
        # dc.Clear()
        # bmp = wx.Bitmap("/home/pi/Desktop/GoBox/Troubleshooting_GUI/dex.png")	# Draw the photograph.
        # dc.DrawBitmap(bmp, 10, 10)						# Absolute position of where to put the picture
    
    ###############################################################################
    def troubleshoot_gopigo(self, event):
        dlg = wx.MessageDialog(self, 'This program tests the GoPiGo for potential issues or problems and will make a log report you can send to Dexter Industries.  \n 1. Make sure the battery pack is connected to the GoPiGo and turn it on.  \n 2. Turn the GoPiGo upside down so the wheels are in the air for the test.  \n 3. Then click OK to begin the test.  \n It takes a few moments for the test to start, and once it has begun, it might take a few minutes to run through all the tests.', 'Troubleshoot the GoPiGo', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        
        ran_dialog = False
        if dlg.ShowModal() == wx.ID_OK:
            print "Start GoPiGo Test!"
            send_bash_command('sudo chmod +x /home/pi/Desktop/GoPiGo/Troubleshooting/all_tests.sh')
            send_bash_command('sudo bash /home/pi/Desktop/GoPiGo/Troubleshooting/all_tests.sh')
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
    def demo_gopigo3(self, event):
        dlg = wx.MessageDialog(self, 'This Demo program will make sure everything is working on your GoPiGo3.  The LEDs on your GoPiGo3 will blink for one second, and the GoPiGo3 will move forward, and then backwards.  So make sure it is on the floor so it does not fall off the table! \n\nMake sure your batteries are connected to the GoPiGo, motors are connected, and it is turned on.  Be sure to unplug the power supply wall adapter from the GoPiGo3. It is best to be working through wifi, but if the GoPiGo3 is connected to your computer with a cable right now, turn it upside down for the demo.  \n\nClick OK to begin.', 'Demonstrate the GoPiGo', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        ran_dialog = False
        if dlg.ShowModal() == wx.ID_OK:
            print "Start GoPiGo3 Demo!"
            # send_bash_command('sudo python /home/pi/Desktop/GoPiGo/Software/Python/other_scripts/demo.py')
            program = "sudo python /home/pi/Dexter/GoPiGo3/Software/Python/hardware_test.py"
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
    def gopigo3(self, event):
        dlg = wx.MessageDialog(self, 'This program tests the GoPiGo3 for potential issues or problems and will make a log report you can send to Dexter Industries.  \n It takes a few moments for the test to start, and once it has begun, it might take a few minutes to run through all the tests.', 'Troubleshoot the GoPiGo3', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        ran_dialog = False
        if dlg.ShowModal() == wx.ID_OK:
            print "Running GoPiGo3 Tests!"
            send_bash_command('sudo chmod +x /home/pi/Dexter/GoPiGo3/Troubleshooting/all_tests.sh')
            send_bash_command('sudo bash /home/pi/Dexter/GoPiGo3/Troubleshooting/all_tests.sh')
            ran_dialog = True
        else:
            print "Cancel GoPiGo3 Tests!"
        dlg.Destroy()
        
        # Depending on what the user chose, we either cancel or complete.
        if ran_dialog:
            dlg = wx.MessageDialog(self, 'All tests are complete. The Log has been saved to Desktop. Please copy it and upload it into our Forums.  www.dexterindustries.com/Forum', 'OK', wx.OK|wx.ICON_INFORMATION)
            dlg.ShowModal()
            dlg.Destroy()
        else:
            dlg = wx.MessageDialog(self, 'GoPiGo3 Test Cancelled', 'Canceled', wx.OK|wx.ICON_HAND)
            dlg.ShowModal()
            dlg.Destroy()
    
    ###############################################################################
    def brickpi3(self, event):
        dlg = wx.MessageDialog(self, 'This program tests the BrickPi3 for potential issues or problems and will make a log report you can send to Dexter Industries.  \n It takes a few moments for the test to start, and once it has begun, it might take a few minutes to run through all the tests.', 'Troubleshoot the BrickPi3', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        ran_dialog = False
        if dlg.ShowModal() == wx.ID_OK:
            print "Running BrickPi3 Tests!"
            send_bash_command('sudo chmod +x /home/pi/Dexter/BrickPi3/Troubleshooting/all_tests.sh')
            send_bash_command('sudo bash /home/pi/Dexter/BrickPi3/Troubleshooting/all_tests.sh')
            ran_dialog = True
        else:
            print "Cancel BrickPi3 Tests!"
        dlg.Destroy()
        
        # Depending on what the user chose, we either cancel or complete.
        if ran_dialog:
            dlg = wx.MessageDialog(self, 'All tests are complete. The Log has been saved to Desktop. Please copy it and upload it into our Forums.  www.dexterindustries.com/Forum', 'OK', wx.OK|wx.ICON_INFORMATION)
            dlg.ShowModal()
            dlg.Destroy()
        else:
            dlg = wx.MessageDialog(self, 'BrickPi3 Test Cancelled', 'Canceled', wx.OK|wx.ICON_HAND)
            dlg.ShowModal()
            dlg.Destroy()
    
    ###############################################################################
    def grovepi(self, event):
        dlg = wx.MessageDialog(self, 'This program tests the GrovePi for potential issues or problems and will make a log report you can send to Dexter Industries.  \n It takes a few moments for the test to start, and once it has begun, it might take a few minutes to run through all the tests.', 'Troubleshoot the GrovePi', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        ran_dialog = False
        if dlg.ShowModal() == wx.ID_OK:
            print "Running GrovePi Tests!"
            send_bash_command('sudo chmod +x /home/pi/Desktop/GrovePi/Troubleshooting/all_tests.sh')
            send_bash_command('sudo bash /home/pi/Desktop/GrovePi/Troubleshooting/all_tests.sh')
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
            dlg = wx.MessageDialog(self, 'GrovePi Test Cancelled', 'Canceled', wx.OK|wx.ICON_HAND)
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
        
        wx.Icon('/home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/favicon.ico', wx.BITMAP_TYPE_ICO)
        wx.Log.SetVerbose(False)
        
        # Set the frame arguments
        # wx.Frame.__init__(self, None, title="Test and Troubleshoot Dexter Industries Hardware",size=(500,500))
        wx.Frame.__init__(self, None, title="Test and Troubleshoot Dexter Industries Hardware")
        self.panel = MainPanel(self)
        sizer = wx.BoxSizer(wx.VERTICAL)
        sizer.Add(self.panel,1,wx.EXPAND)
        self.SetSizerAndFit(sizer)
        self.Center()


########################################################################
#class Main(wx.App):
    #----------------------------------------------------------------------
#    def __init__(self, redirect=False, filename=None):
#        """Constructor"""
#       wx.App.__init__(self, redirect, filename)
#        dlg = MainFrame()
#        dlg.Show()


if __name__ == "__main__":
    app = wx.App(False)
    frame = MainFrame()
    frame.Show(True)
    app.MainLoop()

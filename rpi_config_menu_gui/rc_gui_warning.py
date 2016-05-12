#!/usr/bin/python
import sys
import wx
import subprocess
import datetime

# sudo cp /home/pi/di_update/Raspbian_For_Robots/rpi_config_menu_gui/rc_gui.desktop /usr/share/applications/rc_gui.desktop
class pi_config_app(wx.Frame):
    def __init__(self,parent,id,title):
        wx.Frame.__init__(self,parent,id,title,size=(450,250))
        self.SetBackgroundColour(wx.WHITE)
        self.parent = parent
        self.initialize()
        # Exit
        exit_button = wx.Button(self, label="Exit", pos=(100,200))
        exit_button.Bind(wx.EVT_BUTTON, self.onClose)
        
        robot = "/home/pi/Desktop/GoBox/Troubleshooting_GUI/dex.png"
        png = wx.Image(robot, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
        wx.StaticBitmap(self, -1, png, (375, 50), (png.GetWidth()-320, png.GetHeight()-10))
        self.Bind(wx.EVT_ERASE_BACKGROUND, self.OnEraseBackground)		# Sets background picture
    
    #----------------------------------------------------------------------
    def OnEraseBackground(self, evt):
        """
        Add a picture to the background
        """
        dc = evt.GetDC()
 
        if not dc:
            dc = wx.ClientDC(self)
            rect = self.GetUpdateRegion().GetBox()
            dc.SetClippingRect(rect)
        dc.Clear()	
        bmp = wx.Bitmap("/home/pi/Desktop/GoBox/Troubleshooting_GUI/dex.png")	# Draw the photograph.
        dc.DrawBitmap(bmp, 0, 400)						# Absolute position of where to put the picture

    def initialize(self):
        sizer = wx.GridBagSizer()
        ok_button = wx.Button(self,-1,label="OK", pos=(225,200))
        sizer.Add(ok_button, (0,1))
        self.Bind(wx.EVT_BUTTON, self.ok_button_OnClick, ok_button)
        
        self.label = wx.StaticText(self,-1,label=u'You are entering the advanced menu for Raspberry Pi settings.\n\nChanging the hostname here is safe,\nbut the other options may render your SD card unusable\nwith Dexter Industries products.\n\nIf you change the password and forget it,\nthere is no way of getting it back.\n\nPress Exit to close or OK to proceed',pos=(5,10))
        sizer.Add( self.label, (1,0),(1,2), wx.EXPAND )
        
        self.Show(True)
        
    def ok_button_OnClick(self,event):
        with open("/home/pi/pi_config_flag.txt", mode='a') as file:
            file.write('%s\n' %(datetime.datetime.now())) 
        process = subprocess.Popen(['nohup','rc_gui'])
        self.Close()
        
    def onClose(self, event):	# Close the entire program.
        self.Close()

if __name__ == "__main__":
    app = wx.App()
    frame = pi_config_app(None,-1,'Raspberry Pi Configuration')
    app.MainLoop()

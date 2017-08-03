#!/usr/bin/python
import sys
import wx
import update_comms_settings
import subprocess
import auto_detect_rpi

x=25
def send_bash_command(bashCommand):
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE) #, stderr=subprocess.PIPE)
	output = process.communicate()[0]
	return output

class line_sensor_app(wx.Frame):
    def __init__(self,parent,id,title):
        wx.Frame.__init__(self,parent,id,title,size=(375,300))
        self.SetBackgroundColour(wx.WHITE)
        self.parent = parent
        self.initialize()
        # Exit
        exit_button = wx.Button(self, label="Exit", pos=(25,265))
        exit_button.Bind(wx.EVT_BUTTON, self.onClose)

        robot = "/home/pi/Desktop/GoBox/Troubleshooting_GUI/dex.png"
        png = wx.Image(robot, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
        wx.StaticBitmap(self, -1, png, (295, 150), (png.GetWidth()-320, png.GetHeight()-10))
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


        if auto_detect_rpi.getRPIGenerationCode() == "RPI3":	#pi3 found
            #Show bluetooth too
            enable_blt_button = wx.Button(self,-1,label="Enable Bluetooth", pos=(x,125))
            sizer.Add(enable_blt_button, (0,1))
            self.Bind(wx.EVT_BUTTON, self.enable_blt_button_OnClick, enable_blt_button)

            self.label_blt = wx.StaticText(self,-1,label=self.current_status("blt"),pos=(x+90,230))
            sizer.Add( self.label_blt, (1,0),(1,2), wx.EXPAND )

        enable_ir_receiver_button = wx.Button(self,-1,label="Enable IR receiver", pos=(x,75))
        sizer.Add(enable_ir_receiver_button, (0,1))
        self.Bind(wx.EVT_BUTTON, self.enable_ir_receiver_button_OnClick, enable_ir_receiver_button)

        enable_uart_button = wx.Button(self,-1,label="Enable UART / BrickPi", pos=(x,25))
        sizer.Add(enable_uart_button, (0,1))
        self.Bind(wx.EVT_BUTTON, self.enable_uart_button_OnClick, enable_uart_button)

        self.label = wx.StaticText(self,-1,label=u'Current Status:',pos=(x,200))
        sizer.Add( self.label, (1,0),(1,2), wx.EXPAND )

        self.label_uart = wx.StaticText(self,-1,label=self.current_status("UART"),pos=(x+90,200))
        sizer.Add( self.label_uart, (1,0),(1,2), wx.EXPAND )

        self.label_ir = wx.StaticText(self,-1,label=self.current_status("ir"),pos=(x+90,215))
        sizer.Add( self.label_ir, (1,0),(1,2), wx.EXPAND )

        self.Show(True)

    def current_status(self, setting):
        if setting=="UART" :
            return "UART / BrickPi "+ ("Enabled" if (update_comms_settings.check_ir_setting()==False and update_comms_settings.check_bt_setting()==False) else "Disabled")
        elif setting=="blt":
            return ("Bluetooth "+ ("Enabled" if update_comms_settings.check_bt_setting() else "Disabled"))
        elif setting=="ir":
            return ("IR Receiver "+ ("Enabled" if update_comms_settings.check_ir_setting() else "Disabled"))

    def update_labels(self):
        # in some cases the bluetooth option is not there
        try:
            self.label_uart.SetLabel(self.current_status("UART"))
            self.label_ir.SetLabel(self.current_status("ir"))
            self.label_blt.SetLabel(self.current_status("blt"))
        except:
            pass

    def enable_ir_receiver_button_OnClick(self,event):
        dlg = wx.MessageDialog(self, 'Enabling IR Receiver', ' ', wx.OK|wx.ICON_INFORMATION)
        dlg.ShowModal()
        dlg.Destroy()

        update_comms_settings.enable_ir_setting()
        update_comms_settings.disable_bt_setting()
        self.update_labels()

    def enable_uart_button_OnClick(self,event):
        dlg = wx.MessageDialog(self, 'Enabling UART', ' ', wx.OK|wx.ICON_INFORMATION)
        dlg.ShowModal()
        dlg.Destroy()

        update_comms_settings.disable_ir_setting()
        update_comms_settings.disable_bt_setting()
        self.update_labels()

    def enable_blt_button_OnClick(self,event):
        dlg = wx.MessageDialog(self, 'Enabling Bluetooth', ' ', wx.OK|wx.ICON_INFORMATION)
        dlg.ShowModal()
        dlg.Destroy()

        update_comms_settings.disable_ir_setting()
        if update_comms_settings.check_bt_setting()==False:
            update_comms_settings.enable_bt_setting()
        self.update_labels()


    def onClose(self, event):	# Close the entire program.
        dlg = wx.MessageDialog(self, 'You must reboot for changes to take effect.  Reboot now?', 'Reboot', wx.OK|wx.CANCEL|wx.ICON_INFORMATION)
        if dlg.ShowModal() == wx.ID_OK:
			# Reboot
            send_bash_command('sudo reboot')
            self.Close()
        else:
			# Do nothing.
            print "No reboot."
        dlg.Destroy()
        self.Close()

if __name__ == "__main__":
    app = wx.App()
    frame = line_sensor_app(None,-1,'Advanced Communication Options')
    app.MainLoop()

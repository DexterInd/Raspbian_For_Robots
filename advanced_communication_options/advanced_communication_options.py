#!/usr/bin/python
import sys
import wx
import update_comms_settings
import subprocess
import auto_detect_rpi

PIHOME="/home/pi"
DEXTER="Dexter"
SCRATCH="Scratch_GUI"
s = "/";
seq = (PIHOME, DEXTER,"lib",DEXTER,SCRATCH) # This is sequence of strings.
SCRATCH_PATH = s.join( seq )+"/"

def send_bash_command(bashCommand):
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE) #, stderr=subprocess.PIPE)
	output = process.communicate()[0]
	return output

class MainPanel(wx.Panel):
    def __init__(self,parent):
    
        wx.Panel.__init__(self, parent=parent)
        self.SetBackgroundStyle(wx.BG_STYLE_CUSTOM)
        self.SetBackgroundColour(wx.WHITE)
        self.frame = parent

        vSizer = wx.BoxSizer(wx.VERTICAL)
        logoSizer = wx.BoxSizer(wx.HORIZONTAL) # goes into vSizer
        mainSizer = wx.BoxSizer(wx.HORIZONTAL) # goes into vSizer
        internalSizer = wx.BoxSizer(wx.VERTICAL)  # goes inside mainSizer
        bottomSizer = wx.BoxSizer(wx.HORIZONTAL) # goes into vSizer

        # font = wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, False, u'Consolas')
        font = wx.Font(12, wx.DEFAULT, wx.NORMAL, wx.NORMAL, False, u'Helvetica')
        self.SetFont(font)

        logo_sizer = wx.BoxSizer(wx.HORIZONTAL)
        bmp = wx.Bitmap(SCRATCH_PATH+"dex.png",type=wx.BITMAP_TYPE_PNG)
        bitmap = wx.StaticBitmap(self, bitmap=bmp)
        bmpW,bmpH = bitmap.GetSize()
        logo_sizer.AddSpacer(20)
        logo_sizer.Add(bitmap, 0, wx.RIGHT|wx.LEFT|wx.EXPAND)

        if auto_detect_rpi.getRPIGenerationCode() == "RPI3":	#pi3 found
            #Show bluetooth too
            self.enable_blt_button = wx.Button(self,-1,label="Enable Bluetooth")
            self.enable_blt_button.Bind(wx.EVT_BUTTON, self.enable_blt_button_OnClick)
            label_blt = wx.StaticText(self,-1,label=self.current_status("blt"))

        self.enable_ir_receiver_button = wx.Button(self,-1,label="Enable IR receiver")
        self.enable_ir_receiver_button.Bind(wx.EVT_BUTTON, self.enable_ir_receiver_button_OnClick)

        self.enable_uart_button = wx.Button(self,-1,label="Enable UART / BrickPi")
        self.enable_uart_button.Bind(wx.EVT_BUTTON, self.enable_uart_button_OnClick)

        label = wx.StaticText(self,-1,label=u'Current Status:')
        label_uart = wx.StaticText(self,-1,label=self.current_status("UART"))
        label_ir = wx.StaticText(self,-1,label=self.current_status("ir"))


        internalSizer.AddSpacer(10)
        internalSizer.Add( self.enable_blt_button, 1)
        internalSizer.AddSpacer(20)
        internalSizer.Add( self.enable_ir_receiver_button, 1)
        internalSizer.AddSpacer(20)
        internalSizer.Add( self.enable_uart_button, 1)
        internalSizer.AddSpacer(20)
        internalSizer.Add( label, 0, wx.EXPAND )
        internalSizer.Add( label_blt, 0, wx.EXPAND )
        internalSizer.Add( label_ir, 0, wx.EXPAND )
        internalSizer.Add( label_uart, 0, wx.EXPAND )

        mainSizer.AddSpacer(30)
        mainSizer.Add(internalSizer, 1, wx.EXPAND)
    

        # Exit
        exit_button = wx.Button(self, label="Exit")
        exit_button.Bind(wx.EVT_BUTTON, self.onClose)

        bottomSizer.AddSpacer(300)
        bottomSizer.Add( exit_button, 0, wx.ALIGN_RIGHT )

        vSizer.Add(logoSizer, 0, wx.SHAPED | wx.EXPAND)
        vSizer.AddSpacer(150)
        vSizer.Add(mainSizer, 1, wx.EXPAND)
        vSizer.AddSpacer(40)
        vSizer.Add(bottomSizer, 1, wx.EXPAND | wx.ALIGN_BOTTOM)
        vSizer.AddSpacer(10)
        self.SetSizerAndFit(vSizer)

    def update_labels(self):
        # in some cases the bluetooth option is not there
        try:
            self.label_uart.SetLabel(self.current_status("UART"))
            self.label_ir.SetLabel(self.current_status("ir"))
            self.label_blt.SetLabel(self.current_status("blt"))
        except:
            pass

    def enable_ir_receiver_button_OnClick(self, event):
        dlg = wx.MessageDialog(self, 'Enabling IR Receiver', ' ', wx.OK|wx.ICON_INFORMATION)
        dlg.ShowModal()
        dlg.Destroy()

        update_comms_settings.enable_ir_setting()
        update_comms_settings.disable_bt_setting()
        self.update_labels()

    def enable_uart_button_OnClick(self, event):
        dlg = wx.MessageDialog(self, 'Enabling UART', ' ', wx.OK|wx.ICON_INFORMATION)
        dlg.ShowModal()
        dlg.Destroy()

        update_comms_settings.disable_ir_setting()
        update_comms_settings.disable_bt_setting()
        self.update_labels()

    def enable_blt_button_OnClick( self, event):
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
        self.frame.Close()
        
    def current_status(self, setting):
        if setting=="UART" :
            return "UART / BrickPi "+ ("Enabled" if (update_comms_settings.check_ir_setting()==False and update_comms_settings.check_bt_setting()==False) else "Disabled")
        elif setting=="blt":
            return ("Bluetooth "+ ("Enabled" if update_comms_settings.check_bt_setting() else "Disabled"))
        elif setting=="ir":
            return ("IR Receiver "+ ("Enabled" if update_comms_settings.check_ir_setting() else "Disabled"))

class MainFrame(wx.Frame):
    def __init__(self):
        wx.Icon(SCRATCH_PATH+'favicon.ico', wx.BITMAP_TYPE_ICO)
        wx.Log.SetVerbose(False)
        wx.Frame.__init__(self, None, title="Advanced Communication Options", size=(400,500))		# Set the fram size

        panel = MainPanel(self)
        self.Center()

class Main(wx.App):
    def __init__(self, redirect=False, filename=None):
        """Constructor"""
        wx.App.__init__(self, redirect, filename)
        dlg = MainFrame()
        dlg.Show()

if __name__ == "__main__":
    app = Main()
    app.MainLoop()

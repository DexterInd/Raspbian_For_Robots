This hack help solves permissions for VNC.

http://stackoverflow.com/questions/20286705/tkinter-through-vnc-without-physical-display

You need to run "xhost +" in the command line before running a program in Scratch.
Finally solved the problem: In the desktop shortcut, use "gksu" instead of sudo to call the startup script for Scratch.
Also took "lxterminal" out of some of the calls.  lxterminal starts open new windows, so I removed that.
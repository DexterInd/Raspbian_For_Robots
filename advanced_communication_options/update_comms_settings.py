import subprocess
debug =1
def send_command(bashCommand):
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE) #, stderr=subprocess.PIPE)
	output = process.communicate()[0]
	return output

def check_ir_setting():
	flag=0
	if 'lirc_dev' in open('/etc/modules').read():
		flag=1
		if debug:
			print "lirc_dev in /etc/modules"

	if 'lirc_rpi gpio_in_pin=15' in open('/etc/modules').read():
		flag=1
		if debug:
			print "lirc_rpi gpio_in_pin=15 in /etc/modules"

	if 'lirc_rpi gpio_in_pin=14' in open('/etc/modules').read():
		flag=1
		if debug:
			print "lirc_rpi gpio_in_pin=14 in /etc/modules"

	if 'dtoverlay=lirc-rpi,gpio_in_pin=14' in open('/boot/config.txt').read():
		flag=1
		if debug:
			print "dtoverlay=lirc-rpi,gpio_in_pin=14 in /boot/config.txt"

	if 'dtoverlay=lirc-rpi,gpio_in_pin=15' in open('/boot/config.txt').read():
		flag=1
		if debug:
			print "dtoverlay=lirc-rpi,gpio_in_pin=15 in /boot/config.txt"

	if flag:
		return True
	return False

def replace_in_file(filename,replace_from,replace_to):
	f = open(filename,'r')
	filedata = f.read()
	f.close()

	newdata = filedata.replace(replace_from,replace_to)

	f = open(filename,'w')
	f.write(newdata)
	f.close()

def disable_ir_setting():
	################################################################################
	# disabling the ir-server service

	# get service status using sytemctl
	is_service_active = send_command("systemctl is-active ir-server.service")
	is_service_enabled = send_command("systemctl is-enabled ir-server.service")


	# display service's short-status summary when debug mode is set
	if debug:
		print("[disable_ir_setting()][is service active = {}]".format(is_service_active))
		print("[disable_ir_setting()][is service enabled = {}]".format(is_service_enabled))


	# if the service is active
	if is_service_active == "active":
		# then stop the service
		send_command("sudo systemctl stop ir-server.service")

		if debug:
			print("[disable_ir_setting()][sent command to stop ir-server.service]")


	# if the service is enabled then disable it
	# when a service is enabled it means the service will start on each boot/reboot
	if is_service_enabled == "enabled":
		# then enable the service
		send_command("sudo systemctl disable ir-server.service")

		if debug:
			print("[disable_ir_setting()][sent command to disable ir-server.service]")

	################################################################################
	# lirc (ir-receiver) settings for disabling it

	if check_ir_setting()==True:
		if debug:
			print "Disabling IR"
		replace_in_file('/etc/modules',"lirc_dev","")
		replace_in_file('/etc/modules',"lirc_rpi gpio_in_pin=15","")
		replace_in_file('/etc/modules',"lirc_rpi gpio_in_pin=14","")
		replace_in_file('/boot/config.txt',"dtoverlay=lirc-rpi,gpio_in_pin=14","")
		replace_in_file('/boot/config.txt',"dtoverlay=lirc-rpi,gpio_in_pin=15","")
	else:
		if debug:
			print "IR already disabled"

def enable_ir_setting():
	################################################################################
	# enabling the ir-server service

	# reload unit-files in case they were modified/added
	send_command("sudo systemctl daemon-reload")

	# get service status using sytemctl
	is_service_enabled = send_command("systemctl is-enabled ir-server.service")
	is_service_active = send_command("systemctl is-active ir-server.service")


	# display service's short-status summary when debug mode is set
	if debug:
		print("[enable_ir_setting()][is service enabled = {}]".format(is_service_enabled))
		print("[enable_ir_setting()][is service active = {}]".format(is_service_active))

	# if the service is inactive
	if not is_service_active == "active":
		# then start the service
		send_command("sudo systemctl start ir-server.service")

		if debug:
			# some debugging
			print("[enable_ir_setting()][sent command to start ir-server.service]")


	# if the service is disabled then enable it
	# when a service is disabled, the service won't start automatically on boot
	if not is_service_enabled == "enabled":
		send_command("sudo systemctl enable ir-server.service")

		if debug:
			# some debugging
			print("[enable_ir_setting()][sent command to enable ir-server.service]")

	################################################################################
	# lirc (ir-receiver) settings for Enabling it

	if 'lirc_dev' in open('/etc/modules').read():
		if debug:
			print "lirc_dev already in /etc/modules"
	else:
		if debug:
			print "lirc_dev added"

		with open('/etc/modules', 'a') as file:
			file.write('lirc_dev\n')

	if 'lirc_rpi gpio_in_pin=15' in open('/etc/modules').read():
		if debug:
			print "lirc_rpi gpio_in_pin=15 already in /etc/modules"
	else:
		if debug:
			print "lirc_rpi gpio_in_pin=15 added"

		with open('/etc/modules', 'a') as file:
			file.write('lirc_rpi gpio_in_pin=15\n')

	if 'dtoverlay=lirc-rpi,gpio_in_pin=15' in open('/boot/config.txt').read():
		if debug:
			print "dtoverlay=lirc-rpi,gpio_in_pin=15 already in /boot/config.txt"
	else:
		if debug:
			print "dtoverlay=lirc-rpi,gpio_in_pin=15 added"

		with open('/boot/config.txt', 'a') as file:
			file.write('dtoverlay=lirc-rpi,gpio_in_pin=15\n')

def check_bt_setting():
	flag=0
	if ('dtoverlay=pi3-miniuart-bt' in open('/boot/config.txt').read()) and ('#dtoverlay=pi3-miniuart-bt' in open('/boot/config.txt').read())==False:
		flag=1
		if debug:
			print "dtoverlay=pi3-miniuart-bt commented, bluetooth not working"
	if flag:
		return False
	return True

def disable_bt_setting():
	if check_bt_setting()==True:
		if('#dtoverlay=pi3-miniuart-bt' in open('/boot/config.txt').read()):	#setting is commented, uncomment it
			replace_in_file('/boot/config.txt',"#dtoverlay=pi3-miniuart-bt","dtoverlay=pi3-miniuart-bt")
		else: #no setting at all
			with open('/boot/config.txt', 'a') as file:
				file.write('dtoverlay=pi3-miniuart-bt\n')

def enable_bt_setting():
	if check_bt_setting()==False:
		replace_in_file('/boot/config.txt',"dtoverlay=pi3-miniuart-bt","#dtoverlay=pi3-miniuart-bt")

def check_pi3():
	f = open('/proc/cpuinfo','r')
	for line in f:
		if line[0:8]=='Hardware':
			hw_id = line[11:18]
	f.close()

	if hw_id=="BCM2709":
		return True
	return False

if __name__ == "__main__":
	print check_ir()
	#disable_ir()
	#enable_ir()

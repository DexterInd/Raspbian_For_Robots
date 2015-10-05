<html><body>
<img src="dexter-logo-sm.png" alt="Dexter Industries!" > <!--- style="width:304px;height:228px;"> -->

<strong><p>Raspbian for Robots.</p></strong>

<BR>
<BR>

<?php

	// Check for Lan IP on ethernet.
	$command="/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'";
	$ethernetIP = exec($command);

	// Did you find an IP address?  If not, get it for wifi
	if(strlen($ethernetIP)  == 0){
		// echo "Nothing in ethernet!  ";
		$command="/sbin/ifconfig wlan0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'";
		$ethernetIP = exec($command);
	}

	// Link for Terminal
	// Enters via port 4200
	$address = "http://".$ethernetIP;
	$address = $address.":4200";
	$address = "<a href=\"".$address;
	$address = $address."\"/> ";
        $bash = '<img src="bash.png" style="width:180px;height:156px;" >';
	$address = $address.$bash;
	$address = $address." <BR> Open Terminal (Command Line Interface). </a>";
	
	$vnc =  '<img src="vnc.png" style="width:180px;height:156px;">';


	// echo $vnc;

	echo $address;

	echo '<BR>';
	echo '<BR>';

	// Link for noVNC
	// Enters via port 8001.
	$address = "http://".$ethernetIP;
	$address = $address.":8001";
	$address = "<a href=\"".$address;
	$address = $address."\"/>";
	$address = $address.$vnc; 
	$address = $address."<BR> Open VNC (Desktop). </a>";
	echo $address;

?>

</body>
</html>

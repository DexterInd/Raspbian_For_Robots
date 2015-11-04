<html>
<head>
    <title>Dexter Industries Raspbian for Robots</title>
    <link rel="stylesheet" href="css/main.css">
</head>

<body>
<br>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="http://www.dexterindustries.com/" target="_blank">
	<img src="dexter-logo-sm.png" alt="Dexter Industries!" >
	</a>
<br>
<strong><p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  <h1>&nbsp;&nbsp;&nbsp; Raspbian for Robots.</h1></p></strong>
<p>
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Welcome to Raspbian for Robots, our custom 
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; software for your Dexter Industries robots!
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; There are two ways to view and program your 
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; robot.  
<br>
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; The easiest and most user friendly 
<br>  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; way for beginners is to go in through VNC 
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (virtual network connections), which will 
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; show you a little desktop in your browser with 
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; icons and folders.
<br>
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If you are more advanced and want to work in the 
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; command line, choose Terminal and have fun!
</p>

<div id="nav">
<CENTER>
<?php
	$space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

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
	$address1 = "http://".$ethernetIP;
	$address1 = $address1.":4200";
	$address1 = "<a href=\"".$address1;
	$address_start_terminal = $address1."\"/>";
        $bash = '<img src="bash.png" style="width:180px;height:156px;" >';
	$address1 = $address_start_terminal.$bash;
	$address1 = $address1."</a> <BR>";

	$address1 = $address1.$address_start_terminal;
	$address1 = $address1."Terminal (Command Line)</a>";
	
	$vnc =  '<img src="vnc.png" style="width:180px;height:156px;">';
	
	// Link for noVNC
	// Enters via port 8001.
	echo $space;
	$address = "http://".$ethernetIP;
	$address = $address.":8001";
	$address = "<a href=\"".$address;
	$address2 = $address."\"/>";
	$address = $address2.$vnc;
	$address = $address."</a>"; 
	$address = $address."<BR>";
	$address = $address.$address2."VNC (Desktop)</a>";
	echo $address;
	
	echo '<BR>';
	echo '<BR>';
	echo $address1;

?>
</CENTER>
</div>
<BR>
<div id="footer">
<h3>Need more help?</h3>

	<ul>
		<li>See more about the <a href="http://www.dexterindustries.com/gopigo-tutorials-documentation/" target="_blank">GoPiGo.</a></li>
		<li>See more about the <a href="http://www.dexterindustries.com/grovepi-tutorials-documentation/" target="_blank">GrovePi.</a></li>
		<li>See more about the <a href="http://www.dexterindustries.com/brickpi-tutorials-documentation/" target="_blank">BrickPi.</a></li>
		<li>Ask a question on our <a href="http://www.dexterindustries.com/forum" target="_blank">forums.</a></li>
	</ul>
</div>

</body>
</html>

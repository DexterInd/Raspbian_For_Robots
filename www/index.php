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
?>

<html>
<head>
    <title>Dexter Industries Raspbian for Robots</title>
    <link rel="stylesheet" href="css/main.css">
    <meta name="viewport" content="width=device-width,initial-scale=1">
</head>

<body>
  <div class="main-container">
            <div class="main wrapper clearfix">
  <header>
	<a href="http://www.dexterindustries.com/" target="_blank">
     <img src="img/dexter-logo-sm.png" class="standard logo" alt="Dexter Industries!" >
     <img src="img/dexter-logo-retina.png" class="retina logo" alt="Dexter Industries!" >
	</a>
  <h1>Raspbian for Robots.</h1>

</header>

<article>
<section>
  <p>
    Welcome to Raspbian for Robots, our custom software for your Dexter Industries robots! There are two ways to view and program your robot.
  </p>
  <p>
    The easiest and most user friendly way for beginners is to go in through VNC (virtual network connections), which will show you a little desktop in your browser with icons and folders.
  </p>
  <p>
    If you are more advanced and want to work in the command line, choose Terminal and have fun!
  </p>
  <section class="vnc">
  <a href="http://<?php echo $ethernetIP; ?>:8001">
    <img src="img/vnc.svg" onerror="this.src='vnc.png'; this.onerror=null;"style="height:128px;">
    <span class="button">Launch VNC</span>
  </a>
    <em>Password: <strong>robots1234</strong></em>

</section>
<section class="bash">
  <a href="https://<?php echo $ethernetIP; ?>:4200">
    <img src="img/bash.svg" onerror="this.src='bash.png'; this.onerror=null;"style="height:128px;">
    <span class="button">Launch Terminal</span>
  </a>
    <em>
      Username: <strong>pi</strong>
      <br/>
      Password: <strong>raspberry</strong>
   </em>
</section>

<footer>
<h3>Need more help?</h3>

	<ul>
    <li>See more about the <a href="http://www.dexterindustries.com/arduberry-tutorials-documentation/?raspbian_for_robots" target="_blank" class="product arduberry">Arduberry.</a></li>
    <li>See more about the <a href="http://www.dexterindustries.com/brickpi-tutorials-documentation/?raspbian_for_robots" target="_blank" class="product brickpi">BrickPi.</a></li>
		<li>See more about the <a href="http://www.dexterindustries.com/gopigo-tutorials-documentation/?raspbian_for_robots" target="_blank" class="product gopigo">GoPiGo.</a></li>
		<li>See more about the <a href="http://www.dexterindustries.com/grovepi-tutorials-documentation/?raspbian_for_robots" target="_blank" class="product grovepi">GrovePi.</a></li>

    <li>Ask a question on our <a href="http://www.dexterindustries.com/forum?raspbian_for_robots" target="_blank" class="product">forums.</a></li>
	</ul>
</footer>
</article>
</div> <!-- #main -->
   </div> <!-- #main-container -->

</body>
</html>

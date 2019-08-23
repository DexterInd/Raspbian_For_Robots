<?php
  $ethcommand = "ifconfig eth0 | grep 'inet ' | cut -d' ' -f10";
  exec($ethcommand, $output, $return_var);
  if (strlen($output[0]) > 0) {
    $eth_ip = $output[0];
  } else {
    $eth_ip = "";
  }
  $wlan0command = "ifconfig wlan0 | grep 'inet ' | cut -d' ' -f10";
  exec($wlan0command, $wlan0output, $return_var);
  if (strlen($wlan0output[0]) > 0) {
    $wlan0_ip = $wlan0output[0];
  } else {
    $wlan0_ip = "";
  }
  $dexhost = $_SERVER['HTTP_HOST'];
?>
<html>
<head>
    <title>Dexter Industries Raspbian for Robots</title>
    <link rel="stylesheet" href="css/main.css">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta http-equiv="cache-control" content="max-age=0" />
    <meta http-equiv="cache-control" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
    <meta http-equiv="pragma" content="no-cache" />
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
</section>
<section class="vnc">
  <a href=" http://<?php echo $dexhost; ?>:8001/vnc.html?host=<?php echo $dexhost; ?>&port=8001&autoconnect=true&password=robots1234&scaleViewport=true">
    <img src="img/vnc.svg" onerror="this.src='img/vnc.png'; this.onerror=null;"style="height:128px;">
    <span class="button">Launch VNC</span>
  </a>
    <em>Password: <strong>robots1234</strong></em>
</section>
<section class="bash">
  <a href="http://<?php echo $dexhost; ?>:4200">
    <img src="img/bash.svg" onerror="this.src='img/bash.png'; this.onerror=null;"style="height:128px;">
    <span class="button">Launch Terminal</span>
  </a>
    <em>
      Username: <strong>pi</strong>
      <br/>
      Password: <strong>robots1234</strong>
  </em>
</section>
<section class="IP">
<?php 
$dexip = "";
foreach ($ips as &$ip) { 
   $dexip = $dexip + $ip; 
} 
?>
    <ul>
        <li>Robot hostname : <?php echo $dexhost; ?> </li>
        <?php if (strlen($wlan0_ip) > 0 ) { ?>
        <li>Robot WiFi IP address : <?php echo $wlan0_ip; ?> </li>
        <?php } ?>
        <?php if (strlen($eth_ip) > 0 ) { ?>
        <li>Robot ethernet IP address : <?php echo $eth_ip; ?> </li>
        <?php } ?>
  </ul>
</section>

<footer>
<h3>Need more help?</h3>

	<ul>
    <li>See more about the <a href="http://www.dexterindustries.com/brickpi-tutorials-documentation/?raspbian_for_robots" target="_blank" class="product brickpi">BrickPi.</a></li>
		<li>See more about the <a href="http://www.dexterindustries.com/gopigo-tutorials-documentation/?raspbian_for_robots" target="_blank" class="product gopigo">GoPiGo.</a></li>
		<li>See more about the <a href="http://www.dexterindustries.com/grovepi-tutorials-documentation/?raspbian_for_robots" target="_blank" class="product grovepi">GrovePi.</a></li>
		<li>See more about the <a href="http://www.dexterindustries.com/pivotpi-tutorials-documentation/" target="_blank" class="product pivotpi">PivotPi</a></li>

    <li>Ask a question on our <a href="http://forum.dexterindustries.com" target="_blank" class="product">forums.</a></li>
	</ul>
</footer>
</article>
</div> <!-- #main -->
</div> <!-- #main-container -->

</body>
</html>

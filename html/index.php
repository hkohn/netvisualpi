<!DOCTYPE html>
<html>
<head>
<title></title>
<meta name="generator" content="Bluefish 2.2.10" >
<meta name="author" content="Holger Kohn">
<meta name="date" content="2021-07-24T13:22:01+0200" >
<meta name="copyright" content="Holger Kohn">
<meta name="keywords" content="">
<meta name="description" content="">
<meta name="ROBOTS" content="NOINDEX, NOFOLLOW">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="content-type" content="application/xhtml+xml; charset=UTF-8">
<meta http-equiv="content-style-type" content="text/css">
<meta http-equiv="expires" content="0">
<meta >
</head>

<body bgcolor="#404040">
<table border="0" align="center" bgcolor="#FFFFFF" width="100%">
<tr bgcolor="#1F2737">
<td>
<table border="0" width="100%">
<tr><td width="100" align="center">
<table><tr>
<td>
</td>
<td bgcolor="#ffffff" align="center"><a href="/index.php" ><img src="netvisualpi-tux.png" width="100" height="100" alt=""><BR>NetvisualPi</a></td>
</tr></table>
</td>
<td>
<table border="1" width="100%">
<tr>
<!--td width="25%" align="center" bgcolor="#E6E6FA">Netzübersicht</td-->
<td width="4%" bgcolor="#008000"></td>
<td width="24%" align="center"><a href="/index.php?section=dashboard"><span style="color:white">Dashboard</span></a></td>
<td width="24%" align="center"><a href="/index.php?section=netoverview"><span style="color:white">Netzübersicht</span></a></td>
<td width="24%" align="center"></td>
<td width="24%" align="center"></td>
</tr>
</table>
<table border="1" width="100%">
<tr>
<!--td width="25%" align="center" bgcolor="#E6E6FA">Netzübersicht</td-->
<td width="4%" bgcolor="#FFA500"></td>
<td width="24%" align="center"><a href="/index.php?section=graphen"><span style="color:white">Graphen</span></a--></td>
<td width="24%" align="center"><!--a href="/index.php?section=urlfilter"><span style="color:white">URL-Filter</span></a--></td>
<td width="24%" align="center"><!--a href="/index.php?section=ipsperre"><span style="color:white">IP-Sperre</span></a--></td>
<td width="24%" align="center"></td>
</tr>
</table>
<table border="1" width="100%">
<tr>
<!--td width="25%" align="center" bgcolor="#E6E6FA">Netzübersicht</td-->
<td width="4%" bgcolor="#FF0000"></td>
<td width="24%" align="center"><a href="/index.php?section=logfiles"><span style="color:white">Logdatei</span></a></td>
<td width="24%" align="center"><a href="/index.php?section=firewall"><span style="color:white">Firewall</span></a></td>
<td width="24%" align="center"><a href="/index.php?section=ddoslog"><span style="color:white">DDoS Logdatei</span></a></td>
<td width="24%" align="center"><a href="/index.php?section=Setup"><span style="color:white">Setup</span></a></td>
</tr>
</table>
</td></tr>
</table>
</td>
</tr>
<tr>
<td>
<?php
function startsWith($string, $startString) { 
  $len = strlen($startString); 
  return (substr($string, 0, $len) === $startString); 
}
if ($_GET['section']=="netoverview") {
  if ($_GET['submit']=="Tagesanzeige") {
      $output = shell_exec('/home/pi/perl/iptables-sort.pl /var/log/netvipi-eth0.log | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
  } elseif (startsWith($_GET['submit'],"netvipi")) {
    $output = shell_exec('/home/pi/perl/iptables-sort.pl /var/www/html/files/'.$_GET['submit'].' | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
  } else {
#    $output = shell_exec('perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
    $output = shell_exec('tail -2000 /var/log/netvipi-eth0.log > /var/www/html/files/tmp.log; /home/pi/perl/iptables-sort.pl /var/www/html/files/tmp.log | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
#    $output = shell_exec('tail -2000 /var/log/netvipi-eth0.log');
  }
  $output = shell_exec('dot -Tsvg -o /var/www/html/tmp.svg /var/www/html/files/tmp.dot');
  print "<table width='100%'>";
  print "<tr><td width='120' valign='top' bgcolor='#b0b0b0'>";
  #print "<select name='Protokol'><option>TCP</option></select>";
  print "<form action='index.php'  method='GET'>";
#  print "Ausblenden<BR><input type='checkbox' name='TCP' value='1'>TCP<BR>";
#  print "<input type='checkbox' name='UDP' value='1'>UDP<BR>";
#  print "Sichtbarkeit<BR><select id='view' name='view'><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option><option value='6'>6</option><option value='7'>7</option><option value='8'>8</option><option value='9'>9</option><option value='10'>10</option></select>";
  print "<input type='hidden' name='section' value='netoverview'>";
  print "<BR><BR><button name='submit' type='submit' value='10_Minuten'>10_Minuten_Anzeige</button>";
  print "<button name='submit' type='submit' value='Tagesanzeige'>Tagesanzeige</button>";
  $files = shell_exec('cd /var/www/html/files; ls -t netvipi-eth0.log* | head -30');
  foreach (explode("\n",$files) as $f) {
#  	 $f = preg_replace('/^.*logday/','logday',$f);
    print "<button name='submit' type='submit' value='$f'>$f</button>";
  }
  print "</form>";
  print "</td>";
  print "<td height='800'><object data='tmp.svg' type='image/svg+xml' height='100%'></td>";
  #print "<td height='600'><img src='tmp.svg' width='100%'></td>";
  print "</tr></table>";
}
if (preg_match('/ipanalyze-(.*)$/', $_GET['section'], $outget)) {
  print "$outget[1]";
  $ip=$outget[1];
  if ($_GET['submit']=="Tagesanzeige") {
#    $output = shell_exec('/home/pi/perl/iptables-sort.pl /var/log/netvipi-eth0.log | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
    $output = shell_exec('/home/pi/perl/iptables-sort.pl /var/log/netvipi-eth0.log | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot_ip.pl /var/www/html/files/tmp2.log '.$ip.' > /var/www/html/files/tmp.dot');
  } elseif (startsWith($_GET['submit'],"netvipi")) {
#    $output = shell_exec('/home/pi/perl/iptables-sort.pl /var/www/html/files/'.$_GET['submit'].' | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
    $output = shell_exec('/home/pi/perl/iptables-sort.pl /var/www/html/files/'.$_GET['submit'].' | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot_ip.pl /var/www/html/files/tmp2.log '.$ip.' > /var/www/html/files/tmp.dot');
  } else {
#    $output = shell_exec('perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
#    $output = shell_exec('tail -2000 /var/log/netvipi-eth0.log > /var/www/html/files/tmp.log; /home/pi/perl/iptables-sort.pl /var/www/html/files/tmp.log | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot.pl /var/www/html/files/tmp2.log > /var/www/html/files/tmp.dot');
  $output = shell_exec('tail -2000 /var/log/netvipi-eth0.log > /var/www/html/files/tmp.log; /home/pi/perl/iptables-sort.pl /var/www/html/files/tmp.log | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log; perl /home/pi/perl/log2dot_ip.pl /var/www/html/files/tmp2.log '.$ip.' > /var/www/html/files/tmp.dot');
#    $output = shell_exec('tail -2000 /var/log/netvipi-eth0.log');
  }
  $output = shell_exec('dot -Tsvg -o /var/www/html/tmp.svg /var/www/html/files/tmp.dot');
  print "<table width='100%'>";
  print "<tr><td width='120' valign='top' bgcolor='#b0b0b0'>";
  print "<form action='index.php'  method='GET'>";
#  print "Ausblenden<BR><input type='checkbox' name='TCP' value='1'>TCP<BR>";
#  print "<input type='checkbox' name='UDP' value='1'>UDP<BR>";
#  print "Sichtbarkeit<BR><select id='view' name='view'><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option><option value='6'>6</option><option value='7'>7</option><option value='8'>8</option><option value='9'>9</option><option value='10'>10</option></select>";
  print "<input type='hidden' name='section' value='".$_GET['section']."'>";
  print "<BR><BR><button name='submit' type='submit' value='10_Minuten'>10_Minuten_Anzeige</button>";
  print "<button name='submit' type='submit' value='Tagesanzeige'>Tagesanzeige</button>";
#  $files = shell_exec('ls -t /var/www/html/files/logday* | head -30');
  $files = shell_exec('cd /var/www/html/files; ls -t netvipi-eth0.log* | head -30');
  foreach (explode("\n",$files) as $f) {
#  	 $f = preg_replace('/^.*logday/','logday',$f);
    print "<button name='submit' type='submit' value='$f'>$f</button>";
  }
  print "</td>";
  print "<td height='800'>".$_GET['submit']."<BR><object data='tmp.svg' type='image/svg+xml' width='100%'></td>";
  print "</tr></table>";
}
if ($_GET['section']=="graphen") {
  	print "<H1>12 Stunden</H1><img src='/rrdtool/br0-2hour.png'><BR><img src='/rrdtool/eth0-2hour.png'><BR><img src='/rrdtool/eth1-2hour.png'><BR>";
  	print "<H1>Tag</H1><img src='/rrdtool/br0-day.png'><BR><img src='/rrdtool/eth0-day.png'><BR><img src='/rrdtool/eth1-day.png'><BR>";
  	print "<H1>Woche</H1><img src='/rrdtool/br0-week.png'><BR><img src='/rrdtool/eth0-week.png'><BR><img src='/rrdtool/eth1-week.png'><BR>";
  	print "<H1>Monat</H1><img src='/rrdtool/br0-month.png'><BR><img src='/rrdtool/eth0-month.png'><BR><img src='/rrdtool/eth1-month.png'><BR>";
  	print "<H1>Jahr</H1><img src='/rrdtool/br0-year.png'><BR><img src='/rrdtool/eth0-year.png'><BR><img src='/rrdtool/eth1-year.png'><BR>";
}
if ($_GET['section']=="logfiles") {
  $output = shell_exec('tail -50 /var/log/netvipi-eth0.log');
  $output2 = preg_replace("/\n/", "<BR>", $output);
  print "<table width='100%'><tr><td align='center'>$output2</td></tr></table>";
}
if ($_GET['section']=="ddoslog") {
  $output = shell_exec('tail -50 /var/log/netvipi-ddos.log');
  $output2 = preg_replace("/\n/", "<BR>", $output);
  print "<table width='100%'><tr><td align='center'>$output2</td></tr></table>";
}
if ($_GET['section']=="dashboard") {
  $output = shell_exec('uptime');
  print "uptime: $output<BR>";
  $output = shell_exec('netstat -i');
  print "<textarea rows='8' cols='80'>netstat -i: $output</textarea><BR>";
  print "<img src='/rrdtool/br0-2hour.png'><BR><img src='/rrdtool/eth0-2hour.png'><BR><img src='/rrdtool/eth1-2hour.png'><BR>";
  #print "<table width='100%'><tr><td align='center'><img src='vnstat_h.jpg'><BR><img src='vnstat_d.jpg'></td></tr></table>";
}
if ($_GET['section']=="firewall") {
  $output = shell_exec('sudo /usr/sbin/iptables -L');
  $output2 = preg_replace("/\n/", "<BR>", $output);
  print "<table width='100%'><tr><td align='center'>$output2</td></tr></table>";
}
if ($_GET['section']=="Setup") {
  print "DDoS aktivieren <input type='checkbox' id='ddos-active' name='ddos-active'><BR>";
  print "Telegram-BOT-Token <textarea id='telegram-token' name='text' cols='35' rows='1'></textarea>";
  print "<BR><BR><button name='submit' type='submit' value='setup_speichern'>Setup speichern</button>";
}
?>
<?php
if (isset($_GET['section'])) {
} else {
  print "<table width='100%'><tr><td align='center'><img src='netvisualpi-overview.png' width='1000' height='464' alt='overview'></td></tr></table>";
}
?>
</td></tr>
<table width="100%">
<tr bgcolor="#1F2737">
<td>
<table width="100%"><tr><td><a href="/dokumentation.php" target="_blank"><span style="color:white">Dokumentation</span></a></td>
<?php
  $output = shell_exec('ifconfig eth0 | grep "ether" | cut -d " " -f 10 | sed -e "s/://g"');
  print "<td><a href='mailto:support@netvisualpi.de?subject=Support%20für%20netvipi$output'><span style='color:white'>Support</span></a></td><td width='250'><span style='color:white'>Serial#: netvipi$output</span></td>";
?>
<td width="100" align="right"><span style="color:white">Version 0.9.3</span></td></tr></table>
</td>
</tr>
</table>
</body>
</html>

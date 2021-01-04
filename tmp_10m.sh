#!/bin/bash
D=`date --date="10 Minutes ago" +%H:%M | sed -e 's/.$//' | sed -e 's/^/ /'` ; tail -2000 /var/log/netvipi-eth0.log | grep "$D.:" > /var/www/html/files/tmp.log
/home/pi/perl/iptables-sort.pl /var/www/html/files/tmp.log | sort | uniq -c | sort -nr > /var/www/html/files/tmp2.log

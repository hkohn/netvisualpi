D=`date --date="yesterday" +%Y%m%d`
/home/pi/perl/iptables-sort.pl /var/log/netvipi-eth0.log.1 | sort | uniq -c | sort -nr > /var/www/html/files/logday-$D.log

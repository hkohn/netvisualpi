rsync -Pav /perl /home/pi/
rsync -Pav ./*.sh /home/pi/
rsync -Pav --exclude=files --exclude=rrdtool /html /var/www/
rsync -Pav rules.v* /etc/iptables/
crontab -l > crontab.txt

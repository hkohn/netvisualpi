rsync -Pav /home/pi/perl ./
rsync -Pav /home/pi/*.sh ./
rsync -Pav --exclude=files --exclude=rrdtool /var/www/html ./
rsync -Pav /etc/rsyslog.d/netvisualpi.conf ./
rsync -Pav /etc/hostname ./
rsync -Pav /etc/logrotate.d/netvisiual ./
cp /etc/iptables/rules.v* ./
crontab -l > crontab.txt

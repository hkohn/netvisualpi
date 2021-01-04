apt-get install bridge-utils
apt-get install apache2
apt-get install php7.3
apt-get install havp
apt-get install graphviz

apt-get install dnsutils
apt-get install fwbuilder

rsync -Pav /perl /home/pi/
rsync -Pav ./*.sh /home/pi/
rsync -Pav --exclude=files --exclude=rrdtool /html /var/www/
rsync -Pav rules.v* /etc/iptables/
crontab -l > crontab.txt

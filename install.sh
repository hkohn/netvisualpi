apt-get update

apt-get -y install bridge-utils
apt-get -y install apache2
apt-get -y install php7.3
apt-get -y install havp
apt-get -y install graphviz
apt-get -y install iptables-persistent
apt-get -y install rsyslog
apt-get -y install rrdtool
apt-get -y install librrds-perl
apt-get -y install squid

apt-get -y install dnsutils
apt-get -y install fwbuilder
apt-get -y install wireshark

rsync -Pav ./perl /home/pi/
rsync -Pav ./*.sh /home/pi/
rsync -Pav --exclude=files --exclude=rrdtool ./html /var/www/
rsync -Pav rules.v* /etc/iptables/
rsync -Pav netvisualpi.conf /etc/rsyslog.d/
rsync -Pav hostname /etc/
rsync -Pav netvisiual /etc/logrotate.d/
rsync -Pav squid.conf /etc/squid/ 
rsync -Pav interfaces /etc/network/
rsync -Pav default-ssl.conf /etc/apache2/sites-enabled/
rm -rf /etc/apache2/sites-enabled/000-default.conf

mkdir /var/lib/rrd
chmod 775 /var/lib/rrd
mkdir /var/www/html/rrdtool
chmod 775 /var/www/html/rrdtool
mkdir /var/www/html/files/
chmod 775 /var/www/html/files
chmod 777 /var/www/html/rrdtool
chmod 777 /var/www/html/tmp.svg

cpan Net/Subnet.pm

# crontab -l > crontab.txt

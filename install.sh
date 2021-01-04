apt-get update

apt-get -y install bridge-utils
apt-get -y install apache2
apt-get -y install php7.3
apt-get -y install havp
apt-get -y install graphviz
apt-get -y install iptables-persistent
apt-get -y install rsyslog
apt-get -y install rrdtool

apt-get -y install dnsutils
apt-get -y install fwbuilder
apt-get -y install wireshark

rsync -Pav ./perl /home/pi/
rsync -Pav ./*.sh /home/pi/
rsync -Pav --exclude=files --exclude=rrdtool ./html /var/www/
rsync -Pav rules.v* /etc/iptables/
rsync -Pav netvisualpi.conf /etc/rsyslog.d/
rsync -Pav hostname /etc/
# crontab -l > crontab.txt

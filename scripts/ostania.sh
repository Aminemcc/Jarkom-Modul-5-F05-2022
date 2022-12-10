echo '
auto eth0
iface eth0 inet static
	address 10.31.20.2
	netmask 255.255.255.252

auto eth1
iface eth1 inet static
	address 10.31.16.1
	netmask 255.255.254.0

auto eth2
iface eth2 inet static
	address 10.31.18.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.31.19.1
	netmask 255.255.255.248
' > /etc/network/interfaces

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

#Strix
route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.31.20.1

apt-get update
apt-get install isc-dhcp-relay -y

#10.31.4.130 = WISE
echo '
SERVERS="10.31.4.130"
INTERFACES="eth0 eth1 eth2 eth3"
OPTIONS=
' > /etc/default/isc-dhcp-relay

echo "
net.ipv4.ip_forward=1
" > /etc/sysctl.conf

service isc-dhcp-relay restart

#Nomor 4
iptables -A FORWARD -d 10.31.19.0/29 -m time --weekdays Sat,Sun -j REJECT
iptables -A FORWARD -d 10.31.19.0/29 -m time --timestart 00:00 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
iptables -A FORWARD -d 10.31.19.0/29 -m time --timestart 16:01 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT

#Nomor 5

iptables -A PREROUTING -t nat -p tcp --dport 80 -d 10.31.19.2 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.31.19.3:80
iptables -A PREROUTING -t nat -p tcp --dport 443 -d 10.31.19.3 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.31.19.2:443

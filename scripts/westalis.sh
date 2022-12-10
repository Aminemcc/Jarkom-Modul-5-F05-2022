echo '
auto eth0
iface eth0 inet static
	address 10.31.8.2
	netmask 255.255.255.252

auto eth1
iface eth1 inet static
	address 10.31.0.1
	netmask 255.255.252.0

auto eth2
iface eth2 inet static
	address 10.31.4.1
	netmask 255.255.255.128

auto eth3
iface eth3 inet static
	address 10.31.4.129
	netmask 255.255.255.248
' > /etc/network/interfaces

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

#Strix
route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.31.8.1

apt-get update
apt-get install isc-dhcp-relay -y

echo '
SERVERS="10.31.4.130"
INTERFACES="eth0 eth1 eth2 eth3"
OPTIONS=
' > /etc/default/isc-dhcp-relay

echo "
net.ipv4.ip_forward=1
" > /etc/sysctl.conf

service isc-dhcp-relay restart
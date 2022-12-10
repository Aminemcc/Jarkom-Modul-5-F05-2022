echo '
auto eth0
iface eth0 inet static
    address 10.31.4.130
    netmask 255.255.255.248
    gateway 10.31.4.129
' > /etc/network/interfaces

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install isc-dhcp-server -y

echo 'INTERFACES="eth0"' > /etc/default/isc-dhcp-server

#WISE / EDEN
echo '
subnet 10.31.4.128 netmask 255.255.255.248 {   
}
' > /etc/dhcp/dhcpd.conf

#Forger
echo '
subnet 10.31.4.0 netmask 255.255.255.128 {
    range 10.31.4.2 10.31.4.63;
    option routers 10.31.4.1;
    option broadcast-address 10.31.4.127;
    option domain-name-servers 10.31.4.131;
    default-lease-time 300;
    max-lease-time 6900;
}
' >> /etc/dhcp/dhcpd.conf

#Desmond
echo '
subnet 10.31.0.0 netmask 255.255.252.0 {
    range 10.31.0.2 10.31.2.189;
    option routers 10.31.0.1;
    option broadcast-address 10.31.3.255;
    option domain-name-servers 10.31.4.131;
    default-lease-time 300;
    max-lease-time 6900;
}
' >> /etc/dhcp/dhcpd.conf

#Blackbell
echo '
subnet 10.31.16.0 netmask 255.255.254.0 {
    range 10.31.16.2 10.31.17.1;
    option routers 10.31.16.1;
    option broadcast-address 10.31.17.255;
    option domain-name-servers 10.31.4.131;
    default-lease-time 300;
    max-lease-time 6900;
}
' >> /etc/dhcp/dhcpd.conf

#Briar
echo '
subnet 10.31.18.0 netmask 255.255.255.0 {
    range 10.31.18.2 10.31.18.201;
    option routers 10.31.18.1;
    option broadcast-address 10.31.18.255;
    option domain-name-servers 10.31.4.131;
    default-lease-time 300;
    max-lease-time 6900;
}
' >> /etc/dhcp/dhcpd.conf

#Garden & SSS
echo '
subnet 10.31.19.0 netmask 255.255.255.248 {
}
' >> /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart


#Nomor 3
iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j DROP





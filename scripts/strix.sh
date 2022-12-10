echo '
auto eth0
iface eth0 inet static
    address 192.168.122.2
    netmask 255.255.255.252

#Ostania
auto eth1
iface eth1 inet static
	address 10.31.20.1
	netmask 255.255.255.252

#Westalis
auto eth2
iface eth2 inet static
    address 10.31.8.1
    netmask 255.255.255.252
' > /etc/network/interfaces

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

iptables -t nat -A POSTROUTING -o eth0 -j SNAT -s 10.31.0.0/19 --to-source 192.168.122.2
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.31.0.0/19

#Internet
route add -net 0.0.0.0/0 netmask 0.0.0.0 gw 192.168.122.1
#Westalis
route add -net 10.31.0.0 netmask 255.255.240.0 gw 10.31.8.2
#Ostania
route add -net 10.31.16.0 netmask 255.255.248.0 gw 10.31.20.2

#Nomor 2
iptables -A FORWARD -d 10.31.4.130 -i eth0 -p tcp -j DROP
iptables -A FORWARD -d 10.31.4.130 -i eth0 -p udp -j DROP

iptables -A FORWARD -d 10.31.4.131 -i eth0 -p tcp -j DROP
iptables -A FORWARD -d 10.31.4.131 -i eth0 -p udp -j DROP

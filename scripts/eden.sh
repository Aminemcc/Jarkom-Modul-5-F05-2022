echo '
auto eth0
iface eth0 inet static
    address 10.31.4.131
    netmask 255.255.255.248
    gateway 10.31.4.129
' > /etc/network/interfaces

echo 'nameserver 192.168.122.1' > /etc/resolv.conf


apt-get update
apt-get install bind9 -y

echo '
options {
        directory "/var/cache/bind";
        forwarders {
                192.168.122.1;
        };
        allow-query{any;};
        auth-nxdomain no;
        listen-on-v6 { any; };
};
' > /etc/bind/named.conf.options

rndc reload
service bind9 restart
service bind9 status

#Nomor 3
iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j DROP

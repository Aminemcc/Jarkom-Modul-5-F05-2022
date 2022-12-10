iptables -A FORWARD -d 10.31.4.130 -i eth0 -p tcp --dport 80 -j DROP
iptables -A FORWARD -d 10.31.4.130 -i eth0 -p udp --dport 80 -j DROP

iptables -A FORWARD -d 10.31.4.131 -i eth0 -p tcp --dport 80 -j DROP
iptables -A FORWARD -d 10.31.4.131 -i eth0 -p udp --dport 80 -j DROP

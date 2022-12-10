# Jarkom-Modul-5-F05-2022

## Kelompok F05

| Nama | NRP |
| ------------- | ------------- |
| Muhammad Amin | 5025201251 |
| Elthan Ramanda B | 5025201092 |
| Aiffah Kiysa Waafi | 5025201202 |


## Topologi

<img src="images/topologi.jpg">
<br>

Keterangan :

- Eden adalah DNS Server
- WISE adalah DHCP Server
- Garden dan SSS adalah Web Server
- Jumlah Host pada Forger adalah 62 host
- Jumlah Host pada Desmond adalah 700 host
- Jumlah Host pada Blackbell adalah 255 host
- Jumlah Host pada Briar adalah 200 host

## Soal

Setelah kalian mempelajari semua modul yang telah diberikan, Loid ingin meminta bantuan untuk terakhir kalinya kepada kalian. Dan kalian dengan senang hati mau membantu Loid.

a. Tugas pertama kalian yaitu membuat topologi jaringan sesuai dengan rancangan yang diberikan Loid dibawah ini: (topologi ada di atas)

b. Untuk menjaga perdamaian dunia, Loid ingin meminta kalian untuk membuat topologi tersebut menggunakan teknik CIDR atau VLSM setelah melakukan subnetting.

c. Anya, putri pertama Loid, juga berpesan kepada anda agar melakukan Routing agar setiap perangkat pada jaringan tersebut dapat terhubung.

d. Tugas berikutnya adalah memberikan ip pada subnet Forger, Desmond, Blackbell, dan Briar secara dinamis menggunakan bantuan DHCP server. Kemudian kalian ingat bahwa kalian harus setting DHCP Relay pada router yang menghubungkannya.


1. Agar topologi yang kalian buat dapat mengakses keluar, kalian diminta untuk mengkonfigurasi Strix menggunakan iptables, tetapi Loid tidak ingin menggunakan MASQUERADE.
2. Kalian diminta untuk melakukan drop semua TCP dan UDP dari luar Topologi kalian pada server yang merupakan DHCP Server demi menjaga keamanan.
3. Loid meminta kalian untuk membatasi DHCP dan DNS Server hanya boleh menerima maksimal 2 koneksi ICMP secara bersamaan menggunakan iptables, selebihnya didrop.
4. Akses menuju Web Server hanya diperbolehkan disaat jam kerja yaitu Senin sampai Jumat pada pukul 07.00 - 16.00.
5. Karena kita memiliki 2 Web Server, Loid ingin Ostania diatur sehingga setiap request dari client yang mengakses Garden dengan port 80 akan didistribusikan secara bergantian pada SSS dan Garden secara berurutan dan request dari client yang mengakses SSS dengan port 443 akan didistribusikan secara bergantian pada Garden dan SSS secara berurutan.
6. Karena Loid ingin tau paket apa saja yang di-drop, maka di setiap node server dan router ditambahkan logging paket yang di-drop dengan standard syslog level.

Loid berterima kasih pada kalian karena telah membantunya. Loid juga mengingatkan agar semua aturan iptables harus disimpan pada sistem atau paling tidak kalian menyediakan script sebagai backup.

## Jawaban

Untuk CIDR, tabel IP, dll dapat diakses di sheet berikut : 
<a href="https://docs.google.com/spreadsheets/d/1QPYwuEAQ5l8qt_IMnyCh6rmjS_KktdDHTEU0QfUO9sY/edit?usp=sharing">GSHEET</a>

### Topologi

<image src="images/topologi.jpg"><br>

### Labelling

<image src="images/label.jpg"><br>

Jika VLSM dibutuhkan netmask /19, jika CIDR dapat dilihat pada section berikutnya <br>

Disini akan digunakan CIDR karena routing lebih simpel <br>
(banyak tetangga >= banyak konfigurasi routing) 

### CIDR

<image src="images/cidr.jpg"><br>

### NID

<image src="images/nid.jpg"><br>

### Network Configuration

Network configuration dapat diatur dengan klik kanan pada suatu node di GNS atau langsung edit file <br>
"/etc/network/interfaces".<br>
Jangan lupa di restart setelah mengatur network configuration

Jika eth0 nya static, jangan lupa edit file "/etc/resolv.conf" <br>
```
echo 'nameserver 192.168.122.1' > /etc/resolv.conf
```
Strix <br>
```
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
```
Ostania<br>
```
#Strix
auto eth0
iface eth0 inet static
	address 10.31.20.2
	netmask 255.255.255.252

#Blackbell(255host)
auto eth1
iface eth1 inet static
	address 10.31.16.1
	netmask 255.255.254.0

#Briar(200host)
auto eth2
iface eth2 inet static
	address 10.31.18.1
	netmask 255.255.255.0

#Garden & SSS
auto eth3
iface eth3 inet static
	address 10.31.19.1
	netmask 255.255.255.248
```
Westalis<br>
```
#Strix
auto eth0
iface eth0 inet static
	address 10.31.8.2
	netmask 255.255.255.252

#Desmond(700host)
auto eth1
iface eth1 inet static
	address 10.31.0.1
	netmask 255.255.252.0

#Forger(62host)
auto eth2
iface eth2 inet static
	address 10.31.4.1
	netmask 255.255.255.128

#Eden & Wise
auto eth3
iface eth3 inet static
	address 10.31.4.129
	netmask 255.255.255.248
```
Blackbell, Briar, Desmond, dan Forger <br>
```
auto eth0
iface eth0 inet dhcp
```
Garden <br>
```
#Ostania
auto eth0
iface eth0 inet static
	address 10.31.19.2
	netmask 255.255.255.248
	gateway 10.31.19.1
```
SSS <br>
```
#Ostania
auto eth0
iface eth0 inet static
	address 10.31.19.3
	netmask 255.255.255.248
	gateway 10.31.19.1
```
Eden <br>
```
#Westalis
auto eth0
iface eth0 inet static
    address 10.31.4.131
    netmask 255.255.255.248
    gateway 10.31.4.129
```
Wise<br>
```
#Westalis
auto eth0
iface eth0 inet static
    address 10.31.4.130
    netmask 255.255.255.248
    gateway 10.31.4.129
```
### Routing

Strix <br>
```
#Internet / NAT
route add -net 0.0.0.0/0 netmask 0.0.0.0 gw 192.168.122.1
#Westalis
route add -net 10.31.0.0 netmask 255.255.240.0 gw 10.31.8.2
#Ostania
route add -net 10.31.16.0 netmask 255.255.248.0 gw 10.31.20.2
```
Ostania <br>
```
#Strix
route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.31.20.1
```
Westalis <br>
```
#Strix
route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.31.8.1
```

Note : <br>
1. Algoritma routing mendahulukan Subnet dengan range lebih kecil
2. 0.0.0.0/0 : Semua IP dari 0.0.0.0 - 255.255.255.255

#### Other

Ostania : DHCP Relay<br>
```
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
```
Westalis : DHCP Relay<br>
```
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
```
Wise : DHCP Server<br>
```
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
```
ada subnet yang dibiarkan kosong karena pada DHCP Relay kita mention interface nya, tetapi kita tidak membutuhkannya untuk menjadi dynamic IP, sehingga kita kosongin saja agar tidak error DHCP Server-nya, mungkin bisa dicoba-coba sendiri untuk lebih lanjut.

Eden : DNS Server<br>
```
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
```
DNS Server berguna agar file /etc/resolv.conf pada DHCP Client untuk otomatis mengarah ke Eden yang dimana Eden akan mengarahkan ke DNS Server NAT "192.168.122.1"
### Nomor 1

Masquerade berarti otomatis mendapatkan IP dari interface sekarang, karena tidak boleh menggunakan MASQUERADE, maka ada 2 cara, yaitu dengan mengubah IP dari interface yang terhubung ke NAT menjadi static

Network Konfigurasi Strix <br>
edit network configuration atau ubah file /etc/network/interfaces

NID NAT : 192.168.122.0 <br>
IP NAT : 192.168.122.1

```
auto eth0
iface eth0 inet static
    address 192.168.122.2
    netmask 255.255.255.252
```

Perlu diperhatikan interface strix yang terhubung dengan NAT adalah eth0 lalu jalankan command ini

Pada Router Strix :<br>
```
iptables -t nat -A POSTROUTING -o eth0 -j SNAT -s 10.31.0.0/19 --to-source 192.168.122.2
```

1. -t nat : tabel NAT
2. -A POSTROUTING : tambahkan pengaturan POSTROUTING
3. -o eth0 : pada eth0
4. -j SNAT : ubah Source IP
5. -s 10.31.0.0/19 : pada rentang 10.31.0.0 - 10.31.31.255
6. --to-source 192.168.122.2 : ubah menjadi ip eth0

### Nomor 2

Lakukan drop packet TCP / UDP dari luar topologi (berasal dari NAT) yang menuju ke Eden & Wise

Pada Router Strix :<br>
```
iptables -A FORWARD -d 10.31.4.130 -i eth0 -p tcp --dport 80 -j DROP
iptables -A FORWARD -d 10.31.4.130 -i eth0 -p udp --dport 80 -j DROP

iptables -A FORWARD -d 10.31.4.131 -i eth0 -p tcp --dport 80 -j DROP
iptables -A FORWARD -d 10.31.4.131 -i eth0 -p udp --dport 80 -j DROP

```

1. -A FORWARD : tambahkan pengaturan FORWARD
2. -d [IP] : dengan destination address
3. -i eth0 : yang berasal dari eth0
4. -p [tcp/udp/...] : protocol tcp / udp / lainnya
5. --dport 80 : dengan destination port 80
6. -j DROP : lakukan drop paket

Hati-hati karena koneksi yang berasal dari Eden & Wise tidak akan bisa mengakses internet semisal untuk download package, dll yang menggunakan protokol tcp & udp

### Nomor 3

Pada Eden & Wise : <br>
```
iptables -A INPUT -p icmp -m connlimit --connlimit-above 2 --connlimit-mask 0 -j DROP
```

1. -A INPUT : tambahkan pengaturan INPUT
2. -p icmp : protocol icmp 
3. -m connlimit --connlimit-above 2 --connlimit-mask 0 : batas koneksi maksimal 2 bersamaan
4. -j DROP : lakukan drop paket

#### Nomor 4

Hanya bisa diakses pada Senin-Kamis 07:00-16:00

Perlu diketahuai bahwa <br>
Pada subnet 10.31.19.0/29 terdapat IP Garden, SSS, serta interface pada Ostania yang terhubung <br>

Pada Ostania : <br>
```
iptables -A FORWARD -d 10.31.19.0/29 -m time --weekdays Sat,Sun -j REJECT
iptables -A FORWARD -d 10.31.19.0/29 -m time --timestart 00:00 --timestop 06:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
iptables -A FORWARD -d 10.31.19.0/29 -m time --timestart 16:01 --timestop 23:59 --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT
```
Hati-hati karena interface Ostania yang terhubung ke Garden & SSS juga terikut tidak bisa dihubungi

Untuk mengubah date pada Ostania untuk testing gunakan perintah berikut

```
date --set "16 Sep 2002 00:00:00"
```

### Nomor 5

Karena ingin dibuat merata, maka kita tinggal mengubah destination address setiap paket kelipatan 2. Untuk mengubah destination address, digunakanlah PREROUTING

10.31.19.2 : IP Garden <br>
10.31.19.3 : IP SSS <br>

Pada Ostania : <br>
```
iptables -A PREROUTING -t nat -p tcp --dport 80 -d 10.31.19.2 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.31.19.3:80

iptables -A PREROUTING -t nat -p tcp --dport 443 -d 10.31.19.3 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 10.31.19.2:443
```

### Nomor 6

...
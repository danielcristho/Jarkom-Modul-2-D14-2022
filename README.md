# Jarkom-Modul-2-D14-2022

Lapres Praktikum Jarkom Modul 2

| Nama                      | NRP      |
|---------------------------|----------|
|Gloriyano C. Daniel Pepuho |5025201121|

## Cara Pengerjaan

### Nomor 1
WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet

**Konfigurasi IP address**
* Ostania

```
auto eth0
iface eth0 inet static
	address 192.168.122.222
	netmask 255.255.255.0
	gateway 192.168.122.1

auto eth1
iface eth1 inet static
	address 192.192.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.192.2.1
	netmask 255.255.255.0


auto eth3
iface eth3 inet static
	address 192.192.3.1
	netmask 255.255.255.0
```

* SSS

```
auto eth0
iface eth0 inet static
	address 192.192.1.2
	netmask 255.255.255.0
	gateway 192.192.1.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

* Garden

```
auto eth0
iface eth0 inet static
	address 192.192.1.3
	netmask 255.255.255.0
	gateway 192.192.1.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

* Berlint
```
auto eth0
iface eth0 inet static
	address 192.192.2.2
	netmask 255.255.255.0
	gateway 192.192.2.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

* Eden

```
auto eth0
iface eth0 inet static
	address 192.192.2.3
	netmask 255.255.255.0
	gateway 192.192.2.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

* WISE

```
auto eth0
iface eth0 inet static
	address 192.192.3.2
	netmask 255.255.255.0
	gateway 192.192.3.1
	up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

**Konfigurasi Ostania(router)**
* Agar client bisa terhubung ke internet, perlu menambahkan settingan iptbales. Kemudian simpan kedalam file **.bashrc**

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.192.0.0/16
echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.192.0.0/16
" >> .bashrc
```

**Konfigurasi client**

```
apt update
apt install lynx dnsutils -y
```

**Konfigurasi DNS Server**
* Install dns-server
```
apt update
apt install bind9 -y
```

**Konfigurasi Web Server**
* Install apache2, php dan aplikasi tambahan

```
apt update
apt install php apache2 libapache2-mod-php7.0  -y
apt install git ca-certificates lynx -y
```

### Nomor 2
Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan akses wise.yyy.com dengan alias www.wise.yyy.com pada folder wise.

* Pertama konfigurasi forward dan reverse pada **/etc/bind/named.conf.local**

```
zone "wise.d14.com" {
        type master;
        file "/etc/bind/wise/forward";
};
zone "3.192.192.in-addr.arpa" {
        type master;
        file "/etc/bind/wise/reverse";
};
```

* Kemudian buat folder **wise** di **/etc/bind** untuk menyimpan konfigurasi forward dan reverse

```
mkdir /etc/bind/wise
cp db.local wise/forward
cp db.local wise/reverse
```
* Konfigurasi file forward, seprti konfigurasi dibawah

```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.D14.com. root.wise.D14.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      wise.D14.com.
@               IN      A       192.192.2.3 ; IP Eden
www             IN      CNAME   wise.D14.com.
```

### Nomor 3
Setelah itu ia juga ingin membuat subdomain eden.wise.yyy.com dengan alias www.eden.wise.yyy.com yang diatur DNS-nya di WISE dan mengarah ke Eden.

* Kemudian konfigurasi subdomain pada file **/etc/bind/wise/forward**

```
eden            IN      A       192.192.2.3 ; IP Eden
www.eden        IN      CNAME   wise.D14.com.
```

### Nomor 4
Buat juga reverse domain untuk domain utama

* Kemudian konfigurasi file reverse pada folder **/etc/bind/wise**

```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.D14.com. root.wise.D14.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
3.192.192.in-addr.arpa.         IN      NS      wise.D14.com.
2
```

### Nomor 5
Agar dapat tetap dihubungi jika server WISE bermasalah, buatlah juga Berlint sebagai DNS Slave untuk domain utama

* Tambahkan konfigurasi sebagai master pada **/etc/bind/named.conf.local** di WISE

```
zone "wise.D14.com" {
        type master;
        notify yes;
        allow-transfer { 192.192.2.2; }; //IP Berlint
        also-notify { 192.192.2.2; }; //IP Berlint
        file "/etc/bind/wise/forward";
```

* Kemudian tambahkan konfigurasi sebagai slave pada **/etc/bind/named.conf.local** di Berlint

```
zone "wise.D14.com" {
        type slave;
        masters { 192.192.3.2; };
        file "/var/lib/bind/forward";
};
```

### Nomor 6
Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation

* Pertama tambahkan beberapa konfigurasi pada file **/etc/bind/named.conf.options** di WISE dan Eden.

```
options {
        directory "/var/cache/bind";
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
```
* Tambahkan konfigurasi pada ***/etc/bind/wise/forward**
```
ns1             IN      A       192.192.2.3
operation       IN      NS      ns1
```

* Tambahkan juga konfigurasi pada ***/etc/bind/operation/forward** di Eden
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     operation.wise.D14.com. root.operation.wise.D14.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      operation.wise.D14.com.
@               IN      A       192.192.2.3
operation       IN      A       192.192.2.3
www             IN      CNAME   operation.wise.D14.com.
```

* Kemudian tambahkan konfigurasi lagi pada **/etc/bind/named.conf.local** di Berlint

```
zone "operation.wise.D14.com.in-addr.arpa" {
        type master;
        file "/etc/bind/operation/forward";
};
```
### Nomor 7
Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias www.strix.operation.wise.yyy.com yang mengarah ke Eden

* Tambahkan konfigurasi pada **/etc/bind/operation** di Berlint

```
strix           IN      A       192.199.2.3
www.strix       IN      A       192.199.2.3
```

### Nomor 8
Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver. Pertama dengan webserver www.wise.yyy.com. Pertama, Loid membutuhkan webserver dengan DocumentRoot pada /var/www/wise.yyy.com

* Clone resources

```
git clone https://github.com/danielcristho/Jarkom-Modul-2-D14-2022.git
```

* Copy beberapa resources ke directory **/var/www/**

```
cp wise /var/www/wise.D14.com -r
cp eden.wise /var/www/eden.wise.D14.com -r
cp wise /var/www/strix.operation.wise.D14.com -r
```
* Konfigurasi Apache pada direktori **/etc/apache2/sites-available/000-default.conf** di Eden.

```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.D14.com
        ServerName www.wise.D14.com
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

### Nomor 9
Setelah itu, Loid juga membutuhkan agar url www.wise.yyy.com/index.php/home dapat menjadi menjadi www.wise.yyy.com/home

* Tambahkan alias
```
   Alias "/home" "/var/www/wise.D14.com/index.php/home"
```

* Testing
```
lynx wise.D14.com/index.php/home
```

## Catatan
- Untuk memudahkan pengerjaan saya mengubah IP eth0 menjadi static agar IP nya tidak berubah ketika ingin diakses kembali.
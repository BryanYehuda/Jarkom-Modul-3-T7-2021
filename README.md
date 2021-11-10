# Jarkom-Modul-3-T7-2021      
### Laporan Resmi Pengerjaan Sesi Lab Jaringan Komputer     
        
#### Nama Anggota Kelompok :      
1. Naufal Aprilian (05311940000007)     
2. Bryan Yehuda Mannuel (05311940000021)      
3. Mulki Kusumah    

## Jawaban Modul 
  
### SOAL 4        
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.30 - [prefix IP].3.50  

### Jawaban Soal 4    
Lakukan konfigurasi untuk rentang IP yang akan diberikan pada file  `/etc/dhcp/dhcpd.conf` dengan cara menambahkan konfigurasi berikut ini 
```
subnet 10.45.3.0 netmask 255.255.255.0 {
    range  10.45.3.30 10.45.3.50;
    option routers 10.45.3.1;
    option broadcast-address 10.45.3.255;
    option domain-name-servers 10.45.2.2;
    default-lease-time 720;
    max-lease-time 7200;
}
```
Dengan begitu kita telah menentukan ip range  dengan menambahkan `range  10.45.3.30 10.45.3.50;`pada subnet interface switch 3 yang terhubung ke fosha pada eth3


### SOAL 5
Client mendapatkan DNS dari EniesLobby dan client dapat terhubung dengan internet melalui DNS tersebut.

### Jawaban Soal 5
Untuk client mendapatkan DNS dari EniesLobby diperlukan konfigurasi pada file `/etc/dhcp/dhcpd.conf` dengan `option domain-name-servers 10.45.2.2;`

Supaya semua client dapat terhubung internet pada EniesLobby diberikan konfigurasi pada `file /etc/bind/named.conf.options` dengan
```
options {
        directory \"/var/cache/bind\";

        forwarders {
                8.8.8.8;
                8.8.8.4;
        };

        // dnssec-validation auto;
        allow-query { any; };
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
```
#### TESTING
Dengan mengkonfigurasi DHCP server dan DHCP Relay seleuruh Client yang berada pada subnet interface switch 1 dan switch 3 akan otomatis mendapatkan IP pada rentang yang telah dikonfigurasi. Untuk contohnya adalah sebagai berikut:

**Loguetown**      
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/loguetown-5.png?raw=true)       

**Alabasta**      
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/alabasta-5.png?raw=true)     

**TottoLand**       
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/Totoland-5.png?raw=true)

**Skypie**       
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/skypie-5.png?raw=true)

Semua Client juga akan bisa connect ke internet

**Loguetown**        
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/loguetown-test.png?raw=true)

**Alabasta**     
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/alabasta-test.png?raw=true)

**TottoLand**      
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/Totoland-test.png?raw=true)

**Skypie**      
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/skypie-test.png?raw=true)

### SOAL 6
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 6 menit sedangkan pada client yang melalui Switch3 selama 12 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 120 menit.

#### Jawaban Soal 6
Pada subnet interface switch 1 dan 3 ditambahkan konfigurasi berikut pada file `/etc/dhcp/dhcpd.conf`
```
subnet 10.45.1.0 netmask 255.255.255.0 {
    ...
    default-lease-time 360; 
    max-lease-time 7200;
    ...
}
subnet 10.45.3.0 netmask 255.255.255.0 {
    ...
    default-lease-time 720;
    max-lease-time 7200;
    ...
}
```

### SOAL 7
Luffy dan Zoro berencana menjadikan Skypie sebagai server untuk jual beli kapal yang dimilikinya dengan alamat IP yang tetap dengan `IP [prefix IP].3.69`

#### Jawaban Soal 7
Menambahkan konfigurasi untuk fixed address pada `/etc/dhcp/dhcpd.conf`
```
host Skypie {
    hardware ethernet be:c0:ff:37:bb:09;
    fixed-address 10.45.3.69;
}
```
Setelah itu tidak lupa untuk mengganti konfigurasi pada file `/etc/network/interfaces` dengan 
```
auto eth0
iface eth0 inet dhcp
hwaddress ether be:c0:ff:37:bb:09
```
Maka Skypie akan mendapatkan IP `10.45.3.69`
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-fix-ip-skypie.png?raw=true)

### SOAL 8
Loguetown digunakan sebagai client Proxy agar transaksi jual beli dapat terjamin keamanannya, juga untuk mencegah kebocoran data transaksi.

Pada Loguetown, proxy harus bisa diakses dengan nama `jualbelikapal.yyy.com` dengan port yang digunakan adalah `5000`

#### Jawaban Soal 8
**Proxy Water7**    
Menambahkan konfigurasi pada `/etc/squid/squid.conf`  
```
echo "
http_port 5000
visible_hostname Water7
#http_access allow all
" 
```
Melakukan restart service bind9 dengan `service bind9 restart`  

**Server Enieslobby**    
Menambahkan konfigurasi pada `/etc/bind/named.conf.local`  
```
echo "
zone \"jualbelikapal.t07.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t07.com\";
};
" 
```
Membuat Directory baru dengan `mkdir /etc/bind/jarkom/ `         
Menambahkan konfigurasi pada `/etc/bind/jarkom/jualbelikapal.t07.com`  
```
echo "
\$TTL    604800
@       IN      SOA     jualbelikapal.t07.com. root.jualbelikapal.t07.com. (
                        2021100401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      jualbelikapal.t07.com.
@       IN      A       10.45.2.3
" 
```
Melakukan restart service bind9 dengan `service bind9 restart`

#### TESTING
Melakukan Export env http_proxy dengan`export http_proxy="http://jualbelikapal.t07.com:5000" `
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-8-1.png?raw=true)

Ketika diakses akan tetap bisa menggunakan proxy
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-8-2.png?raw=true)     

### SOAL 9
Agar transaksi jual beli lebih aman dan pengguna website ada dua orang, proxy dipasang autentikasi user proxy dengan `enkripsi MD5` dengan dua username, yaitu `luffybelikapalyyy` dengan password `luffy_yyy` dan `zorobelikapalyyy` dengan password `zoro_yyy`

#### Jawaban Soal 9
**Proxy Water7**    
Menambahkan konfigurasi pada `/etc/squid/squid.conf`  
```
htpasswd -cbm /etc/squid/passwd luffybelikapalt07 luffy_t07
htpasswd -bm /etc/squid/passwd zorobelikapalt07 zoro_t07
echo "
http_port 5000
visible_hostname Water7
#http_access allow all


auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access deny all
" 
```
Melakukan restart service squid dengan `service squid restart`  

#### TESTING
Testing Luffy dan Zoro     
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-9-1.png?raw=true)

Ketika diakses akan tetap bisa menggunakan proxy     
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-9-2.png?raw=true)

### SOAL 10
Transaksi jual beli tidak dilakukan setiap hari, oleh karena itu akses internet dibatasi hanya dapat diakses setiap hari Senin-Kamis pukul 07.00-11.00 dan setiap hari Selasa-Jumat pukul 17.00-03.00 keesokan harinya (sampai Sabtu pukul 03.00) 

#### Jawaban Soal 10
**Proxy Water7**    
Menambahkan konfigurasi pada `/etc/squid/acl.conf`  
```
echo "
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time WHFA 00:00-03:00
"
```


Menambahkan konfigurasi pada `/etc/squid/squid.conf`  
```
echo "
include /etc/squid/acl.conf

http_port 5000
visible_hostname Water7
#http_access allow all


auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow USERS AVAILABLE_WORKING
http_access deny all
"
```
Melakukan restart service squid dengan `service squid restart`  

#### TESTING

![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-10-1.png?raw=true)
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-10-2.png?raw=true)

### SOAL 11
Agar transaksi bisa lebih fokus berjalan, maka dilakukan redirect website agar mudah mengingat website transaksi jual beli kapal. Setiap mengakses `google.com`, akan diredirect menuju `super.franky.yyy.com` dengan website yang sama pada soal shift modul 2. Web server `super.franky.yyy.com` berada pada node Skypie

#### Jawaban Soal 11
**Server EniesLobby**    
Menambahkan konfigurasi pada `/etc/bind/named.conf.local`  
```
echo "
zone \"jualbelikapal.t07.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t07.com\";
};

zone \"super.franky.t07.com\" {
        type master;
        file \"/etc/bind/kaizoku/super.franky.t07.com\";
};
"
```
Membuat Directory baru dengan `mkdir /etc/bind/kaizoku/`         
Menambahkan konfigurasi pada `/etc/bind/kaizoku/super.franky.t07.com`  
```
echo "
\$TTL    604800
@       IN      SOA     super.franky.t07.com. root.super.franky.t07.com. (
                        2021100401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      super.franky.t07.com.
@       IN      A       10.45.3.69
"
```
Melakukan restart service bind9 dengan `service bind9 restart`  

**Server Skypie**    
Membuat Directory baru dengan `mkdir /var/www/super.franky.t07.com`    
Mengambil konten dan melakukan unzip pada github dengan
```
wget https://raw.githubusercontent.com/FeinardSlim/Praktikum-Modul-2-Jarkom/main/super.franky.zip -O /root/super.franky.zip
unzip -o /root/super.franky.zip -d  /root
cp -r /root/super.franky/. /var/www/super.franky.t07.com/
```
Menambahkan konfigurasi pada `/etc/apache2/sites-available/super.franky.t07.com.conf`  
```
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/super.franky.t07.com
        ServerName super.franky.t07.com
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
        <Directory /var/www/super.franky.t07.com/public>
                Options +Indexes
        </Directory>
</VirtualHost>
"
```
Melakukan
```
a2ensite super.franky.t07.com
a2dissite 000-default  
```
Melakukan restart service apache2 dengan `service apache2 restart`  

**Proxy Water7**     
Menambahkan konfigurasi pada `/etc/squid/squid.conf`  
```
echo "
include /etc/squid/acl.conf

http_port 5000
visible_hostname Water7
#http_access allow all


auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED

#client acl for the lan
acl lan src 10.45.3.0/24 10.45.1.0/24

#to deny \"google.com\"
acl badsites dstdomain .google.com

#Deny with redirect to Google SafeSearch for lan
deny_info http://super.franky.t07.com lan

#Deny badsites to lan
http_reply_access deny badsites lan

http_access allow USERS AVAILABLE_WORKING
http_access deny all
dns_nameservers 10.45.2.2
" 
```
Melakukan restart service squid dengan `service squid restart`  

#### TESTING

![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-11-1.png?raw=true)

Ketika diakses akan tetap bisa menggunakan proxy     
![](https://github.com/n0ppp/Jarkom-Modul-3-T7-2021/blob/main/image/testing-nomor-11-2.png?raw=true)
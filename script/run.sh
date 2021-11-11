#!/bin/bash
Foosha(){
apt-get update
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.45.0.0/16
apt-get install isc-dhcp-relay -y

# nomor 2 - 7

echo "
# What servers should the DHCP relay forward requests to?
SERVERS=\"10.45.2.4\"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES=\"eth1 eth3 eth2\"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=\"\"
" > /etc/default/isc-dhcp-relay
service isc-dhcp-relay restart
}
Jipangu(){
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y

echo "
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. \"eth0 eth1\".
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server

echo " 
subnet 10.45.2.0 netmask 255.255.255.0 {
}
subnet 10.45.1.0 netmask 255.255.255.0 {
    range  10.45.1.20 10.45.1.99;
    range  10.45.1.150 10.45.1.169;
    option routers 10.45.1.1;
    option broadcast-address 10.45.1.255;
    option domain-name-servers 10.45.2.2;
    default-lease-time 360;
    max-lease-time 7200;
}

subnet 10.45.3.0 netmask 255.255.255.0 {
    range  10.45.3.30 10.45.3.50;
    option routers 10.45.3.1;
    option broadcast-address 10.45.3.255;
    option domain-name-servers 10.45.2.2;
    default-lease-time 720;
    max-lease-time 7200;
}

host Skypie {
    hardware ethernet be:c0:ff:37:bb:09;
    fixed-address 10.45.3.69;
}
" >  /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
}


EniesLobby() {
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
# nomor 2 - 7
echo "
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
" > /etc/bind/named.conf.options
service bind9 restart

# nomor 8
echo "
zone \"jualbelikapal.t07.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t07.com\";
};
" > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom/ 

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
" > /etc/bind/jarkom/jualbelikapal.t07.com

service bind9 restart
# nomor 11
echo "
zone \"jualbelikapal.t07.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t07.com\";
};

zone \"super.franky.t07.com\" {
        type master;
        file \"/etc/bind/kaizoku/super.franky.t07.com\";
};
" > /etc/bind/named.conf.local

mkdir /etc/bind/kaizoku/
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
" > /etc/bind/kaizoku/super.franky.t07.com

service bind9 restart

}

Water7(){
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install libapache2-mod-php7.0 -y
apt-get install squid -y
# nomor 7 - 8

## Water7 -> Proxy Server
echo "
http_port 5000
visible_hostname Water7
#http_access allow all
" > /etc/squid/squid.conf

service squid start

# nomor 9
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

" > /etc/squid/squid.conf

# nomor 10

## Water7 -> Proxy Server

echo "
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time WHFA 00:00-03:00
" >/etc/squid/acl.conf

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
" > /etc/squid/squid.conf

service squid restart

# nomor 11
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
" > /etc/squid/squid.conf

# nomor 12

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

dns_nameservers 10.45.2.2


acl multimedia url_regex -i \.png$ \.jpg$
acl bar proxy_auth luffybelikapalt07
delay_pools 1
delay_class 1 1
delay_parameters 1 1250/3200
delay_access 1 allow multimedia bar
delay_access 1 deny ALL
http_access deny ALL
" > /etc/squid/squid.conf

service squid restart
}

Loguetown(){
apt-get update
apt-get install speedtest-cli -y
apt-get install ca-certificates openssl -y
apt-get install dnsutils -y
apt-get install lynx -y
export http_proxy="http://jualbelikapal.t07.com:5000"
}

Alabasta(){
apt-get update
apt-get install dnsutils -y
apt-get install lynx -y
export http_proxy="http://jualbelikapal.t07.com:5000"
}

Skypie(){
apt-get update
# nomor 8
apt-get install apache2 -y
service apache2 start
apt-get install php -y
apt-get install libapache2-mod-php7.0 -y
apt-get install ca-certificates openssl -y
apt-get install git -y
apt-get install unzip -y
apt-get install wget -y
apt-get install lynx -y


# nomor 11
mkdir /var/www/super.franky.t07.com

wget https://raw.githubusercontent.com/FeinardSlim/Praktikum-Modul-2-Jarkom/main/super.franky.zip -O /root/super.franky.zip
unzip -o /root/super.franky.zip -d  /root
cp -r /root/super.franky/. /var/www/super.franky.t07.com/

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
" > /etc/apache2/sites-available/super.franky.t07.com.conf
a2ensite super.franky.t07.com
a2dissite 000-default  
service apache2 restart

export http_proxy="http://jualbelikapal.t07.com:5000"
}


TottoLand(){
apt-get update
apt-get install dnsutils -y
apt-get install lynx -y
export http_proxy="http://jualbelikapal.t07.com:5000"
}



if [ $HOSTNAME == "Foosha" ]
then
    Foosha
elif [ $HOSTNAME == "Jipangu" ]
then
    Jipangu
elif [ $HOSTNAME == "EniesLobby" ]
then
    EniesLobby
elif [ $HOSTNAME == "Water7" ]
then
    Water7
elif [ $HOSTNAME == "Loguetown" ]
then
    Loguetown
elif [ $HOSTNAME == "Alabasta" ]
then
    Alabasta
elif [ $HOSTNAME == "TottoLand" ]
then
    TottoLand
elif [ $HOSTNAME == "Skypie" ]
then
    Skypie
fi
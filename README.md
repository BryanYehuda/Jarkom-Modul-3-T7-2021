# Jarkom-Modul-3-T7-2021
### SOAL 1 dan 2

#### JAWABAN

### SOAL 3

#### JAWABAN

### SOAL 4
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.30 - [prefix IP].3.50 (4)
#### JAWABAN
Lakukan konfigurasi untuk rentang IP yang akan diberikan pada file  /etc/dhcp/dhcpd.conf dengan cara menambahkan konfigurasi berikut ini 
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

Dengan begitu kita telah menentukan ip range  dengan menambahkan ```range  10.45.3.30 10.45.3.50;```pada subnet interface switch 3 yang terhubung ke fosha pada eth3
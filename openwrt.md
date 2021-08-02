<p align="center">
    <img src="https://github.com/kopijahe/wifiid-openwrt/blob/master/pics/header.svg" alt="wifi.id ✖ OpenWrt" width="330">
</p>

### **Tutorial Untuk Menangkap dan Memancarkan Kembali Sinyal @wifi.id Menggunakan OpenWrt/LEDE**

### **Langkah-Langkah**
#### **A. Mengatur Hostnames router**
1. Koneksikan perangkat (PC/laptop) ke router (biasanya [192.168.1.1](http://192.168.1.1))

   ![login](pics/01-login-router.png)

2. Masuk ke tab **Network** -> **Hostnames**

   ![hostnames](pics/openwrt-hostnames-1.png)

3. Tekan tombol **Add**, lalu masukkan 2 nilai berikut, lalu tekan tombol **Save** 
   > Hostname: welcome2.wifi.id & logout.wifi.id  
   > IP address: 10.233.16.13

   ![hostnames](pics/openwrt-hostnames-2.png)  
   ![hostnames](pics/openwrt-hostnames-3.png)

4. Kalau sudah sesuai dengan gambar di atas, tekan tombol **Save and Apply**

#### **B Koneksi dengan jaringan @wifi.id (selain seamless<span></span>@wifi.id)**

1. Buka tab **Network** -> **Wifi/Wireless**

   ![wireless](pics/04-interface-wlan.png)

2. Tekan tombol **Scan**

3. Pilih jaringan @wifi.id (jangan pilih yang flashzone-seamless ataupun seamless<span></span>@wifi.id, yang bisa hanya @wifi.id, indischool<span></span>@wifi.id, dan wifi.id@home) dengan menekan tombol **Join Network** di sisi kanan nama jaringan.

   ![scan](pics/05-join-network.png)

4. Biarkan pengaturan bawaan dari OpenWrt/LEDE, langsung tekan **Submit**

   ![settings](pics/06-join-network-2.png)

5. Anda akan dibawa ke pengaturan wifi, tidak perlu ganti apapun, langsung tekan **Save and Apply**

   ![settings2](pics/07-wlan-config.png)

6. Anda akan dibawa kembali ke halaman awal, status koneksi harusnya sudah berwarna biru yang menandakan berhasil terkoneksi ke jaringan

   ![overview](pics/08-wlan-overview.png)

7. Halaman login akan muncul, lakukan login sesuai dengan voucher yang sudah dibeli

   ![interfaces](pics/09-login-page.png)
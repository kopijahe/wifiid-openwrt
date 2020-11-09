<p align="center">
    <img src="https://github.com/kopijahe/wifiid-openwrt/blob/master/pics/header.svg" alt="wifi.id ✖ OpenWrt" width="330">
</p>

### **Tutorial Untuk Menangkap dan Memancarkan Kembali Sinyal @wifi.id Menggunakan OpenWrt/LEDE**

### **Langkah-Langkah**
#### **A. Mengatur DNS router**
1. Koneksikan perangkat (PC/laptop) ke router (biasanya [192.168.1.1](http://192.168.1.1))

   ![login](pics/01-login-router.png)

2. Masuk ke tab **Network** -> **Interfaces**

3. Tekan tombol **Edit** di bagian **LAN**

   ![interfaces](pics/02-interfaces.png)

4. Scroll ke bagian **DHCP Server** di bawah, lalu tekan tab **Advanced Settings**

5. Masukkan `6,118.98.44.10,118.98.44.100` di bagian **DHCP-Options**

   ![dns](pics/03-dns-server.png)

6. Tekan tombol **Save and Apply**

7. Cabut-pasang kembali kabel LAN agar pengaturan ini langsung dipakai oleh perangkat

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

<br><br>
<p align="center">
	<b>Kirim dukungan donasi melalui:</b>
</p>
<p align="center">
    <a href="https://trakteer.id/kopijahe"><img src="https://github.com/kopijahe/wifiid-openwrt/blob/master/pics/trakteer-button.svg" alt="Trakteer ✖ KopiJahe" width="225">
</p>
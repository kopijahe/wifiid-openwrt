### **Tutorial Login Otomatis di Jaringan Venue WMS**

Kesal harus bolak-balik login ketika memakai jaringan Venue WMS di rumah?

### **Persyaratan:**

1. Wajib menggunakan router berbasis openwrt

> :loudspeaker: Jika menggunakan router lain, penulis tidak menjamin bisa dipakai, tapi mungkin saja secara garis besar sama.

2. Menggunakan Google Chrome

3. PuTTY (unduh dan pasang [dari situs ini](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html))

### **Langkah-Langkah**

> :warning: Jika digunakan untuk autologin SSID venue WMS, maka bisa mengikuti langkah-langkah di dokumen [autologin-wms.md](autologin-wms.md)

#### **A. Mengatur hostnames**
1. Koneksikan perangkat (PC/laptop) ke router (biasanya [192.168.1.1](http://192.168.1.1))

   ![login](pics/01-login-router.png)

2. Masuk ke tab **Network** -> **Hostnames**

   ![hostnames-1](pics/autologin/18-hostnames-1.png)

3. Tekan tombol **Add**

   ![hostnames-2](pics/autologin/19-hostnames-2.png)

4. Masukkan ```welcome2.wifi.id``` di bagian **hostname**

5. Di bagian IP, pilih **custom**, lalu masukkan ```10.233.16.32``` (atau kalau tidak bisa: ```10.233.16.13```)

   ![hostnames-3](pics/autologin/20-hostnames-3.png)

6. Ulangi untuk hostname ```lp.wifi.id``` dengan IP ```36.86.63.19``` (atau kalau tidak bisa: ```36.91.226.203```)

7. Tekan tombol **Save & Apply**

   ![hostnames-4](pics/autologin/21-hostnames-4.png)

#### **B. Script autologin**
1. Pastikan sudah terkoneksi ke jaringan @wifi.id **dan belum login**

2. Buka halaman login menggunakan Google Chrome

3. Di halaman login, tekan tombol ```F12```, lalu buka tab **Network** di bagian samping kanan dan centang **Preserve log**

![preserve-log](pics/wms-venue/01-chrome-preserve-log.png)

4. Lakukan login seperti biasa

5. Setelah login, di bagian kanan tadi carilah item berawalan **quarantine.php** dengan scroll ke atas

6. Klik kanan **quarantine.php**, lalu pilih **Copy** -> **Copy as cURL (bash)**

![check-login](pics/wms-venue/02-check-login.png)

7. Buka PuTTY, mulai koneksi **SSH** ke router (biasanya ```192.168.1.1```)

8. Ketikkan: ```opkg update && opkg install curl```

![opkg-update-install-curl](pics/autologin/opkg-update-install-curl.png)

9. Ketikkan: ```vi /etc/login_file.txt```

![login_file](pics/autologin/login_file.png)

10. Sebelum paste hasil dari no. 6, tekan huruf ```i``` terlebih dahulu, perhatikan status di bagian pojok kiri bawah:

![login_file-2](pics/autologin/login_file-2.png)

![login_file-3](pics/autologin/login_file-3.png)

11. Paste hasil dari no. 6 dengan menekan tombol kanan mouse

![login_file-4](pics/wms-venue/login_file-4.png)

12. Hapus baris yang berisikan ```--compressed```

![login_file-5](pics/wms-venue/login_file-5.png)

13. Hapus akhiran ` \`

![login_file-5a](pics/wms-venue/login_file-5a.png)
![login_file-5b](pics/wms-venue/login_file-5b.png)

 > :warning: Jika tidak dihapus, akan mengalami error ini: `/etc/autologin.sh: eval: line 1: syntax error: unterminated quote string`

14. Ganti 4 karakter di bagian sebelum `%40freeMS` dengan `$randomid`

![login_file-5a](pics/wms-venue/login_file-5c.png)
![login_file-5b](pics/wms-venue/login_file-5d.png)


15. Tekan tombol ```ESC``` lalu ketikkan ```:wq``` untuk menyimpan perubahan berkas

![login_file-6](pics/wms-venue/login_file-6.png)

16. Atur supaya berkas ```login_file.txt``` bisa dijalankan dengan mengetikkan ```chmod +x /etc/login_file.txt```

![login_file-7](pics/autologin/login_file-7.png)

16. Unduh script autologin dengan menggunakan perintah: ```curl https://raw.githubusercontent.com/kopijahe/wifiid-openwrt/master/scripts/autologin-wms.sh -o /etc/autologin.sh```

![login_file-8](pics/wms-venue/login_file-8.png)

> :pushpin: Jika terdapat gangguan (misal: script mengulang-ulang login padahal sudah login) di berkas [autologin-wms.sh](scripts/autologin.sh), bisa dicoba menggunakan berkas alternatif:
> 1. [autologin-wms-firefox.sh](scripts/autologin-wms-firefox.sh), dengan perintah: ```curl https://raw.githubusercontent.com/kopijahe/wifiid-openwrt/master/scripts/autologin-wms-firefox.sh -o /etc/autologin.sh```
> 2. [autologin-wms-google.sh](scripts/autologin-wms-google.sh), dengan perintah: ```curl https://raw.githubusercontent.com/kopijahe/wifiid-openwrt/master/scripts/autologin-wms-google.sh -o /etc/autologin.sh```
>
> :warning: Jika menggunakan berkas script alternatif, **tidak perlu** disesuaikan namanya di langkah-langkah berikutnya.
>
> :loudspeaker: Gagal ketika mengunduh script? Lihat solusinya [di sini](https://github.com/kopijahe/wifiid-openwrt/issues/3).

17. Atur supaya berkas ```autologin.sh``` bisa dijalankan dengan mengetikkan ```chmod +x /etc/autologin.sh```

![login_file-9](pics/autologin/login_file-9.png)

18. Buka berkas ```/etc/rc.local``` dengan mengetikkan ```vi /etc/rc.local```

![vi-rc-local](pics/autologin/14-vi-rc-local.png)

19. Tekan huruf ```i```, lalu tambahkan baris ```/bin/sh /etc/autologin.sh &``` di atas baris ```exit 0```

![vi-rc-local-2](pics/autologin/15-vi-rc-local-2.png)

20. Tekan tombol ```ESC``` lalu ketikkan ```:wq``` untuk menyimpan perubahan berkas

21. Ketikkan ```sh /etc/rc.local``` untuk menjalankan script yang sudah kita racik, jika muncul tulisan ```Sudah terkoneksi ke Internet``` maka **anda sudah berhasil**.

![sh-rc-local](pics/autologin/16-sh-rc-local.png)

![result](pics/autologin/login_file-10.png)

> Untuk kedepannya, jika username/password yang digunakan sudah diganti/tidak berlaku, atau proses autologin sudah tidak lagi berjalan, maka hanya perlu mengulangi langkah nomor 9 sampai 16 saja.

<br><br>
> :loudspeaker: **Masih ada pertanyaan lain?** Bisa merujuk ke dokumen [faq-technical-info.md](faq-technical-info.md)
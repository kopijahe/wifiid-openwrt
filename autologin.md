### **Tutorial Login Otomatis di Jaringan @wifi.id**

Kesal harus bolak-balik login ketika memakai jaringan @wifi.id di rumah?

Solusinya ada 2:

1. Pakai jaringan seamless@wifi.id (tidak semua pemancar yang bisa dipakai ada dan bisa sampai login)
2. Pakai router berbasis openwrt dan script untuk login secara otomatis jika jaringan internet terdeteksi tidak tersambung

### **Persyaratan:**

1. Wajib menggunakan router berbasis openwrt

> :loudspeaker: Jika menggunakan router lain, penulis tidak menjamin bisa dipakai, tapi mungkin saja secara garis besar sama.

2. Menggunakan Google Chrome

3. PuTTY (unduh dan pasang [dari situs ini](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html))

### **Langkah-Langkah**
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

![preserve-log](pics/autologin/01-chrome-preserve-log.png)

4. Lakukan login seperti biasa

5. Setelah login, di bagian kanan tadi carilah item berawalan **check-login.php** dengan scroll ke atas

6. Klik kanan **check-login.php**, lalu pilih **Copy** -> **Copy as cURL (bash)**

![check-login](pics/autologin/02-check-login.png)

7. Paste hasilnya ke notepad, hapus baris yang berisikan ```--compressed```

![curl-bash-1](pics/autologin/03-curl-bash-1.png)

8. Jadikan hasilnya ke 1 baris saja seperti ini:

![curl-bash-2](pics/autologin/04-curl-bash-2.png)

9. Tekan tombol ```Ctrl + H```, lalu ganti semua tanda kutip 1 menjadi tanda kutip 2

![curl-bash-3](pics/autologin/05-curl-bash-3.png)

![curl-bash-4](pics/autologin/06-curl-bash-4.png)

10. Buka berkas [autologin.sh](autologin.sh), lalu salin isinya ke berkas baru di notepad

11. Paste hasil dari no. 9 di atas ke bagian ```curl <paste output curl>``` seperti contoh berikut:

![paste-curl](pics/autologin/07-paste-curl.png)

![paste-curl-2](pics/autologin/08-paste-curl-2.png)

12. Buka PuTTY, mulai koneksi **SSH** ke router (biasanya ```192.168.1.1```)

13. Ketikkan: ```opkg update && opkg install curl```

![opkg-update-install-curl](pics/autologin/opkg-update-install-curl.png)

14. Ketikkan: ```vi /etc/autologin.sh```

![vi-autologin](pics/autologin/09-vi-autologin.png)

15. Sebelum paste hasil dari no. 11, tekan huruf ```i``` terlebih dahulu, perhatikan status di bagian pojok kiri bawah:

![vi-autologin-2](pics/autologin/10-vi-autologin-2.png)

![vi-autologin-3](pics/autologin/11-vi-autologin-3.png)

16. Paste hasil dari no. 11 dengan menekan tombol kanan mouse

17. Tekan tombol ```ESC``` lalu ketikkan ```:wq``` untuk menyimpan perubahan berkas

![vi-autologin-4](pics/autologin/12-vi-autologin-4.png)

18. Atur supaya berkas ```autologin.sh``` bisa dijalankan dengan mengetikkan ```chmod +x /etc/autologin.sh```

![chmod-autologin](pics/autologin/13-chmod-autologin.png)

19. Buka berkas ```/etc/rc.local``` dengan mengetikkan ```vi /etc/rc.local```

![vi-rc-local](pics/autologin/14-vi-rc-local.png)

20. Tekan huruf ```i```, lalu tambahkan baris ```/bin/sh /etc/autologin.sh &``` di atas baris ```exit 0```

![vi-rc-local-2](pics/autologin/15-vi-rc-local-2.png)

21. Tekan tombol ```ESC``` lalu ketikkan ```:wq``` untuk menyimpan perubahan berkas

22. Ketikkan ```sh /etc/rc.local``` untuk menjalankan script yang sudah kita racik, jika muncul tulisan ```Connected to the internet``` maka **anda sudah berhasil**.

![sh-rc-local](pics/autologin/16-sh-rc-local.png)

![result](pics/autologin/17-result.png)
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

1. Pastikan sudah terkoneksi ke jaringan @wifi.id **dan belum login**

2. Buka halaman login menggunakan Google Chrome

3. Di halaman login, tekan tombol ```F12```, lalu buka tab **Network** di bagian samping kanan dan centang **Preserve log**

![preserve-log](pics/autologin/01-preserve-log.png)

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

13. Ketikkan: ```vi /etc/autologin.sh```

![vi-autologin](pics/autologin/09-vi-autologin.png)

14. Sebelum paste hasil dari no. 11, tekan huruf ```i``` terlebih dahulu, perhatikan status di bagian pojok kiri bawah:

![vi-autologin-2](pics/autologin/10-vi-autologin-2.png)

![vi-autologin-3](pics/autologin/11-vi-autologin-3.png)

15. Paste hasil dari no. 11 dengan menekan tombol kanan mouse

16. Tekan tombol ```ESC``` lalu ketikkan ```:wq``` untuk menyimpan perubahan berkas

![vi-autologin-4](pics/autologin/12-vi-autologin-4.png)

17. Atur supaya berkas ```autologin.sh``` bisa dijalankan dengan mengetikkan ```chmod +x /etc/autologin.sh```

![chmod-autologin](pics/autologin/13-chmod-autologin.png)

18. Buka berkas ```/etc/rc.local``` dengan mengetikkan ```vi /etc/rc.local```

![vi-rc-local](pics/autologin/14-vi-rc-local.png)

19. Tekan huruf ```i```, lalu tambahkan baris ```/bin/sh /etc/autologin.sh &``` di atas baris ```exit 0```

![vi-rc-local-2](pics/autologin/15-vi-rc-local-2.png)

20. Tekan tombol ```ESC``` lalu ketikkan ```:wq``` untuk menyimpan perubahan berkas

21. Ketikkan ```sh /etc/rc.local``` untuk menjalankan script yang sudah kita racik, jika muncul tulisan ```Connected to the internet``` maka **anda sudah berhasil**.

![sh-rc-local](pics/autologin/16-sh-rc-local.png)

![result](pics/autologin/17-result.png)
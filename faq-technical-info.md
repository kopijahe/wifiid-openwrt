### **Pertanyaan yang sering diajukan dan Dokumen Teknis**

> :loudspeaker: Punya pertanyaan lain? Silahkan buat akun github dan bertanya di [tab Issues](https://github.com/kopijahe/wifiid-openwrt/issues) dengan menekan tombol hijau `New Issue`.

### **DNS Jaringan @wifi.id**

:question: _DNS `118.98.44.10` dan `118.98.44.100` dapatnya dari mana? Karena di daerah saya, DNS tersebut tidak bisa dipakai..._

:bulb: Bisa dilihat dari sewaktu survey menggunakan handphone/laptop, ataupun dari informasi yang diberikan oleh openwrt, bisa dilihat di halaman status koneksi. Contohnya bisa dilihat di gambar-gambar berikut:

   openwrt:
   ![dns-openwrt](pics/technical-info/DNS-openwrt.png)

   android:
   ![dns-android](pics/technical-info/DNS-android.png)

   windows:
   ![dns-windows](pics/technical-info/DNS-windows.png)

Kalau misal di daerah anda ternyata menggunakan alamat server DNS yang berbeda, bisa disesuaikan dengan kondisi di daerah masing-masing.

<br><br>

:question:  _Bagaimana cara tahu alamat IP untuk domain-domain yang diperlukan untuk hostname autologin?_

:bulb: Bisa menggunakan perintah `nslookup <nama domain> <server DNS>`, baik di openwrt ataupun di perangkat lainnya yang terhubung ke jaringan, dan dikonfirmasi setelah dicoba tambahkan sebagai hostname di openwrt. Bila perintahnya tidak menghasilkan IP yang sesuai (misal tetap tidak bisa login), maka disarankan untuk memasang paket `bind-dig` dengan perintah: `opkg update && opkg install bind-dig`. Setelah terpasang, lakukan perintah: `dig @<server DNS> <nama domain>`

   ![dns-nslookup](pics/technical-info/DNS-nslookup.png)
	
   ![dns-dig](pics/technical-info/DNS-dig.png)

### **Autologin**

:question: _Saya kesulitan di bagian mengubah hasil curl ke 1 baris, bisa dibantu cara yang lebih mudah?_

:bulb: Kalau cara manual di notepad bawaan Windows tidak berhasil/dirasa sulit, bisa menggunakan aplikasi [notepad\+\+](https://notepad-plus-plus.org/downloads/), tinggal diblok bagian pergantian baris, lalu tekan tombol `Ctrl + H`, lalu isikan spasi di bagian `Replace with`, lalu tekan tombol `Ctrl + A`.

<br><br>

:question: _Saya lihat di script itu ada jeda pengecekan setiap 10 detik, kenapa tidak dibikin lebih pendek, misalnya 1 detik saja? Supaya kalau terputus pas lagi main game ga nunggu lama-lama..._

:bulb: Biasanya kalau terlalu cepat dalam autologin, akan mendapat status \[Ban IP\] yang menyebabkan gagalnya autologin dan juga kemungkinan turunnya kecepatan internet.

<br><br>

:question: _Saya lihat di script, untuk periksa koneksinya ke domain `periksakoneksi.kopijahe.my.id`, apa aman? Kenapa tidak mengecek ke tempat lain saja?_

:bulb: Aman-aman saja, karena tujuannya hanya mengunduh berkas [cek](https://github.com/kopijahe/periksakoneksi.kopijahe.my.id/blob/master/cek) lalu melihat apakah isinya benar (OK). Saya tidak mendapatkan/mengambil data apapun dari perangkat anda. Soal kenapa kok tidak mengecek ke tempat lain, karena untuk itu butuh paket tambahan (`wget`) yang ukurannya lumayan besar, jadi bisa memberatkan ke pengguna script dengan perangkat yang punya penyimpanan terbatas.

<br><br>

:question: _Bisakah autologin dipakai untuk 2 koneksi berbeda? Router saya bisa 2 frekuensi (2,4 GHz dan 5,8 Ghz), rencananya saya pakai 2 akun dan di loadbalance (misal pakai mwan di openwrt)..._

:bulb: Bisa saja, bikin 2 berkas autologin, misal `autologin.sh` dan `autologin2.sh`, lalu tambahkan parameter `--interface <nama interface>` di awal perintah curl. Misalnya seperti ini: `curl --interface wlan0 ...` di `autologin.sh` dan `curl --interface wlan1 ...` di `autologin2.sh`

### **Lain-lain**

:question: _Bisa di-remote saja lewat teamviewer?_

:bulb: Untuk sementara belum bisa, silahkan diikuti kembali tutorialnya dengan detail. Bila perlu, lakukan factory reset kembali agar pengaturannya tidak tumpang-tindih.

<br><br>

:question: _Donasi?_

:bulb: ![no](https://media1.giphy.com/media/jl7eVqDXCFcm4/giphy.gif)
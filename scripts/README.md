## Penjelasan cara kerja script

Di sini saya akan berusaha menjelaskan logika di balik script autologin milik saya, siapa tahu anda ingin melihat cara kerjanya, atau berminat membuat alternatif lainnya sesuai kondisi jaringan di daerah.

Setiap script juga memiliki dokumentasi internal penjelasan cara kerja jika ingin dipelajari lebih lanjut.

### Tutorial penggunaan script

Untuk tutorial penggunaan script bergambar, bisa merujuk ke dokumen [autologin.md](../autologin.md) untuk jaringan <span</span>@wifi.id atau dokumen [autologin-wms.md](../autologin-wms.md) untuk jaringan Venue WMS.

### login_file.txt
Semua script bergantung kepada berkas ini, yang merupakan hasil ketika kita login hotspot yang direkam oleh browser (di sini saya pakai [Google Chrome](https://google.com/chrome), supaya hasilnya seragam dan mudah dibaca).

Berkas ini mengandung perintah yang diperlukan untuk mengulangi login menggunakan `curl`.

Karena `curl` yang dipakai oleh OpenWrt bawaannya tidak mendukung kompresi, maka baris yang mengandung `--compressed` harus dihapus.

Berkas harus diberi izin eksekusi dengan perintah `chmod +x <nama file>` (biasanya: `chmod +x /etc/login_file.txt`) agar bisa dijalankan oleh sistem.

Lalu berkas ini dibawa ke tempat sementara untuk diproses oleh script sebelum dijalankan untuk keperluan login kembali.

### autologin.sh

Terdiri dari beberapa varian dan tipe, script akan mengecek kondisi jaringan terlebih dahulu ke server-server yang telah ditentukan, jika tidak terdeteksi adanya koneksi internet, baru akan dicoba untuk login kembali. Jadi tidak membombardir server login pihak hotspot (dalam ini <span></span>@wifi.id dan turunannya), yang bisa menyebabkan akun diblokir.

1. autologin.sh / autologin-v2.sh / autologin-wms.sh  
Varian ini mengecek kondisi jaringan dengan cara mengunduh berkas `cek` di server `periksakoneksi.kopijahe.my.id`, dan memastikan bahwa isinya adalah `OK`. Jika isinya berbeda (misal terkena redirect ke halaman login), maka bisa disimpulkan bahwa perlu dilakukan login kembali.

2. autologin-firefox.sh / autologin-firefox-v2.sh / autologin-wms-firefox.sh  
Varian ini mengecek kondisi jaringan dengan cara mengunduh berkas `success.txt` di server `detectportal.firefox.com`, dan memastikan bahwa isinya adalah `success`. Jika isinya berbeda (misal terkena redirect ke halaman login), maka bisa disimpulkan bahwa perlu dilakukan login kembali.

3. autologin-google.sh / autologin-google-v2.sh / autologin-wms-google.sh  
Varian ini mengecek kondisi jaringan dengan cara mengunduh berkas `generate_204` di server `connectivitycheck.gstatic.com` (ini adalah [server bawaan android untuk memeriksa koneksi internet](https://android.googlesource.com/platform/frameworks/base/+/master/services/core/java/com/android/server/ConnectivityService.java#280)), dan memastikan bahwa respon server adalah `HTTP/1.1 204 No Content`. Jika respon server berbeda (misal terkena redirect ke halaman login), maka bisa disimpulkan bahwa perlu dilakukan login kembali.

Semua script akan dirubah namanya menjadi `autologin.sh` ketika diunduh, supaya memudahkan pengguna ketika mengikuti langkah-langkah tutorial.

### Script WMS

Sistem login Venue WMS berbeda dengan jaringan <span></span>@wifi.id, dimana sistem akan menambahkan titik `.` serta 4 karakter angka dan huruf di akhir username pengguna, misal: `usernamesaya` akan dirubah menjadi `usernamesaya.Br0W`.

Pertama kita buat 4 karakter huruf dan angka baru secara acak dari `/dev/urandom`, lalu kita masukkan ke berkas login_file.txt, akan tetapi jika dilakukan seperti ini, setiap kali script melakukan login kembali, 4 karakter tadi akan berubah, yang menyebabkan script tidak akan berjalan...

Maka dari itu, saya atur supaya berkas asli dirubah saja 4 karakter tadi menjadi `kopijahe`, supaya selalu konsisten.

Untuk berjaga-jaga, setiap kali login, nilai alamat IP milik router juga diperbarui oleh script.

### Script v2

Script yang berakhiran v2 memuat logika tambahan untuk berjaga-jaga jika terdapat gangguan yang menyebabkan dilakukannya login secara berulang-ulang (setidaknya 6 kali berturut-turut) dalam waktu singkat, yang menyebabkan perubahan status akun menjadi `[Blocked IP]`. Jika terdeteksi perubahan status ini, maka script akan berusaha meminta alamat IP baru sebelum melakukan login kembali.

Karena cara yang digunakan, script v2 tidak cocok untuk dipakai ketika perangkat autologin bukanlah perangkat yang menangkap langsung sinyal <span><span>@wifi.id (misal: Sinyal <span></span>@wifi.id ditangkap menggunakan CPE 210, lalu dipancarkan lagi menggunakan router openwrt).


### Load-Balance

Untuk pengguna load-balance, bisa menggunakan script ini dengan sedikit modifikasi agar berjalan dengan normal:

Contoh 1: Seamless/Indihome + WMS (berarti ada 1 script berjalan)  
1. Rubah variabel `LB=OFF` menjadi `LB=ON` di script  
2. Rubah variabel `lbinterface` sesuai dengan interface yang dipakai, misal: `wwan`, `wwan1`, `wwan2`

Contoh 2: WMS + <span></span>@wifi.id (berarti ada 2 script berjalan)  
1. Download script yang dibutuhkan, rubah nama script kedua menjadi `autologin2.sh`
2. Rubah nama `login_file.txt` di script `autologin2.sh` menjadi `login_file2.txt`
2. Rubah variabel `LB=OFF` menjadi `LB=ON` di kedua script  
3. Rubah variabel `lbinterface` sesuai dengan interface yang dipakai di kedua script, misal: berkas `autologin.sh` menggunakan `lbinterface=wwan` dan `autologin2.sh` menggunakan `lbinterface=wwan2`

<br><br>
<p align="center">
	<b>Kirim dukungan donasi melalui:</b>
</p>
<p align="center">
    <a href="https://trakteer.id/kopijahe"><img src="https://github.com/kopijahe/wifiid-openwrt/blob/master/pics/trakteer-button.svg" alt="Trakteer ✖ KopiJahe" width="225">
</p>
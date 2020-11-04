<p align="center">
    <img src="https://github.com/kopijahe/wifiid-openwrt/blob/master/pics/header.svg" alt="wifi.id ✖ OpenWrt" width="330">
</p>

## **Tutorial Untuk Menangkap dan Memancarkan Kembali Sinyal @wifi.id**

Di sini saya akan membeberkan cara menangkap dan memancarkan kembali sinyal @wifi.id untuk dipakai bersama-sama (misalnya saya untuk berlangganan internet di rumah). Semua tutorial disertai gambar di hampir semua langkah-langkahnya, sehingga relatif mudah diikuti dan dipahami.

## **Persyaratan:**

1. Terjangkau jaringan @wifi.id (nama wifi/SSID: @wifi.id, indischool<span></span>@wifi.id, wifi.id@home, dan seamless<span></span>@wifi.id). Untuk mengecek ketersediaan pemancar @wifi.id di daerah sekitar, bisa mengecek di fitur "Hotspot Finder" yang tersedia di aplikasi wifi.id GO ([android](https://play.google.com/store/apps/details?id=com.telkom.wifiidgo), [iOS](https://apps.apple.com/id/app/wifi-id-go/id1198078195)), atau melalui situs resmi @wifi.id: https://wifi.id/maps-wifi

2. Punya router jaringan berbasiskan OpenWrt/LEDE atau TP-Link Pharos

3. Punya akun @wifi.id (beli voucher fisik, atau lewat SMS ke 98108, lewat aplikasi wifi.id GO ([android](https://play.google.com/store/apps/details?id=com.telkom.wifiidgo), [iOS](https://apps.apple.com/id/app/wifi-id-go/id1198078195)) atau lewat online marketplace seperti [Tokopedia](https://www.tokopedia.com/streaming/), keterangan lebih lanjut bisa merujuk ke: https://wifi.id/belivoucher )


## Daftar Isi:

* [Identifikasi pemancar <span></span>@wifi.id](access-points.md)  
Berhubung tidak semua pemancar <span></span>@wifi.id bisa digunakan, silahkan coba dulu login menggunakan handphone atau laptop sebelum melanjutkan. Untuk memudahkan, bisa lihat ciri-ciri pemancar yang biasanya bisa dipakai di dokumen ini.

* [Tutorial menggunakan router berbasis OpenWrt/LEDE](openwrt.md)  
Tutorial bergambar dari awal sampai terkoneksi ke jaringan <span></span>@wifi.id menggunakan router berbasis OpenWrt/LEDE.  
Router banyak dijual yang sudah terpasang OpenWrt di marketplace online ([Tokopedia](https://www.tokopedia.com/search?st=product&q=openwrt), [BukaLapak](https://www.bukalapak.com/products?search%5Bkeywords%5D=openwrt), [Shopee](https://shopee.co.id/search?keyword=openwrt)), daftar perangkat selengkapnya bisa lihat [di sini](http://wiki.openwrt.org/toh/start)).  
Karena proses pemasangan firmware OpenWrt berbeda antara satu perangkat dan lainnya, jadi tidak saya bahas di sini.  
> :loudspeaker: Jika menggunakan versi SNAPSHOT, paket tambahan yang dibutuhkan hanya **luci** (dan **wpad** jika ingin terkoneksi dengan seamless<span></span>@wifi.id). Jika belum ada koneksi internet sama-sekali dan tetap ingin terkoneksi dengan jaringan <span></span>@wifi.id, bisa membaca [tutorial ini](https://blog.kopijahe.my.id/posts/tutorial-openwrt-ssh/) tanpa perlu memasang **luci** terlebih dahulu.

* [Tutorial seamless<span></span>@wifi.id](seamless.md)  
Kelebihan sinyal seamless<span></span>@wifi.id ketimbang sinyal @wifi.id lainnya adalah tidak perlu login ulang dalam selang waktu tertentu atau jika tidak dipakai dalam waktu tertentu.  
Karena adanya tambahan langkah-langkah agar terkoneksi ke sinyal seamless<span></span>@wifi.id, maka saya taruh ke dokumen terpisah dari tutorial jaringan <span></span>@wifi.id biasa.

* [Tutorial menggunakan router TP-Link Pharos](tplink-pharos.md)  
Jika tidak tersedia router OpenWrt/LEDE atau sekedar ingin menggunakan router TP-Link Pharos (seri CPE 210/220/510/520/605/610) sebelum dipancarkan kembali.

* [Tutorial jika ingin memancarkan kembali sinyal menggunakan 1 perangkat router openwrt](repeater-mode.md)  
Jika terkendala dana, atau router mendukung 2 jenis sinyal/dual-band wifi (2,4 GHz dan 5,8 GHz)  
Untuk memancarkan kembali sinyal @wifi.id, saya tetap menyarankan untuk menggunakan perangkat/router kedua, jika perangkat anda tidak mendukung wifi dual-band, agar bandwidth tidak terpotong 50% dan lebih stabil dalam penggunaannya.

* [Tutorial autologin di jaringan <span></span>@wifi.id non-seamless](autologin.md)  
Capek login berulang-ulang di jaringan <span></span>@wifi.id? dokumen ini solusinya.

* [Tutorial autologin di jaringan Venue WMS](autologin-wms.md)  
Ingin mengatur ulang jaringan Venue WMS dengan OpenWrt (misal untuk komputer kasir online), tapi terkendala masalah harus login berulang-ulang? dokumen ini solusinya.

* [Informasi teknis dan pertanyaan yang mungkin diajukan](faq-technical-info.md)  
Ada kendala dalam menerapkan tutorial di atas? Bisa merujuk ke dokumen ini untuk beberapa solusinya.  
Pertanyaan anda belum tercantum di sini? Bisa langsung bertanya di [tab Issues](https://github.com/kopijahe/wifiid-openwrt/issues) dengan menekan tombol hijau `New Issue` (harus membuat akun gratis github sebelum bertanya).

<br><br>
<p align="center">
	<b>Kirim dukungan donasi melalui:</b>
</p>
<p align="center">
    <a href="https://trakteer.id/kopijahe"><img src="https://github.com/kopijahe/wifiid-openwrt/blob/master/pics/trakteer-button.svg" alt="Trakteer ✖ KopiJahe" width="225">
</p>
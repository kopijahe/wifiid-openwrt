#!/bin/sh
#
# Script untuk login otomatis di jaringan wifi.id
# Oleh: KopiJahe (https://github.com/kopijahe)

# Jika digunakan untuk Load-Balance,
# bagian di bawah baris ini bisa diubah sesuai kebutuhan
# ===================================================

# Jika digunakan untuk load-balance, rubah baris di bawah menjadi LB=ON
LB=OFF

# Tentukan lokasi berkas login_file.txt
# Jangan lupa untuk berikan izin eksekusi berkas dengan perintah:
# chmod +x /etc/login_file.txt
filelogintxt=/etc/login_file.txt
# Tentukan lokasi berkas sementara
loginwifi=/tmp/login_file.txt

# Jika menggunakan 2 script autologin
# Ganti nama berkas login_file.txt di 2 variabel
# Di atas untuk menghindari konflik

# Dan tentukan interface yang digunakan untuk script
# Misal: wwan1, wwan2
lbinterface=wwan

# =================================================
# Bagian di bawah baris ini tidak perlu diubah-ubah

# Muat library network OpenWrt
. /lib/functions/network.sh

# Selama script berjalan, lakukan hal ini:
while [ true ]; do

# Tentukan interface yang digunakan untuk menangkap sinyal wifi.id secara otomatis
if [[ "$LB" = "OFF" ]]; then
# Bersihkan cache terlebih dahulu
network_flush_cache
# Cari interface jaringan WAN yang digunakan
# untuk koneksi ke jaringan wifi.id
# dan simpan hasilnya di variabel waninterface
network_find_wan waninterface
else
# Jika digunakan untuk load-balance,
# Maka tentukan variabel waninterface secara manual
# Sesuai dengan pengaturan variabel LBInterface
waninterface=$lbinterface
fi

# Tentukan lokasi perangkat radio waninterface (misal: wlan0 atau wlan1)
radiointerface=$(ifstatus $waninterface | jsonfilter -e '@["device"]')

# Tentukan variabel ipblocked
# untuk berjaga-jaga jika IP terblokir
# karena terlalu cepat dalam autologin
ipblocked=$(cat /tmp/last.login | grep -o "Blocked IP")

# Tentukan variabel status dari hasil unduhan berkas
# dari: http://periksakoneksi.kopijahe.my.id/cek
# dan simpan hasilnya di stdout
status=$(curl --interface $radiointerface -L --silent --max-redirs 1 --retry 3 --connect-timeout 5  "http://periksakoneksi.kopijahe.my.id/cek")
# Simpan juga kode status di variabel kodestatus
kodestatus="$?"

# Jika variabel status hasil unduhan tadi sama dengan "OK", maka
if [[ "$status" = "OK" ]]; then
# Beritahu pengguna bahwa sudah terkoneksi dengan Internet
# Dan simpan hasilnya di /tmp/internet.status untuk pengecekan
echo "Sudah terkoneksi dengan Internet" | tee /tmp/internet.status

# Jika hasilnya tidak sama, berarti tidak terkoneksi dengan Internet, maka:
# Cek variabel kodestatus, status yang diketahui saat ini:
# 6 = Couldn't resolve host: Bisa dikarenakan koneksi "bengong" atau hostname halaman landing belum diatur
# 7 = Host is unreachable: Bisa dikarenakan koneksi "bengong" atau hostname halaman landing belum diatur
# 28 = Operation timeout: Halaman cek status koneksi timeour setelah 10 detik
# 47 = Maximum redirects followed: Dikarenakan halaman cek status koneksi diarahkan ulang ke halaman landing

# kasus IP terblokir atau kodestatus 6 dan 7
elif [[ "$ipblocked" = "Blocked IP" ]] || [[ "$kodestatus" = '6' ]] || [[ "$kodestatus" = '7' ]]; then
# Beritahu pengguna bahwa koneksi internet terputus
echo "Koneksi Internet terputus"
# Dan lakukan login
cp $filelogintxt $loginwifi
# Sesuaikan interface yang akan digunakan dengan variable radiointerface
sed -i "s/curl/curl --interface $radiointerface/g" $loginwifi
# Beri izin eksekusi berkas sementara
chmod +x $loginwifi
# Catat tanggal dan jam login terakhir,
echo "Percobaan login terakhir:" | tee -a /tmp/last.login
date | tee -a /tmp/last.login
# Catat pula status percobaan login terakhir
echo "Status percobaan login terakhir:" | tee -a  /tmp/last.login
echo "Minta penggantian alamat IP ke server" | tee /tmp/last.login
# Cari tahu PID dari proses udhcpc koneksi yang terblokir
udhcpcpid=$(cat /var/run/udhcpc-$radiointerface.pid)
# Dan minta penggantian IP ke server
kill -SIGUSR2 $udhcpcpid && ifup $waninterface
# Istirahat selama 20 detik sambil menunggu koneksi
sleep 20
# Dan lakukan login, serta catat semua hasilnya di berkas /tmp/last.login untuk pengecekan
$loginwifi | jsonfilter -e '@["message"]' | tee -a /tmp/internet.status /tmp/last.login | logger

# kasus kodestatus 28, 47 dan lainnya
else
# Beritahu pengguna bahwa koneksi internet terputus
echo "Koneksi Internet terputus"
# Dan lakukan login
cp $filelogintxt $loginwifi
# Sesuaikan interface yang akan digunakan dengan variable radiointerface
sed -i "s/curl/curl --interface $radiointerface/g" $loginwifi
# Beri izin eksekusi berkas sementara
chmod +x $loginwifi
# Catat tanggal dan jam login terakhir,
echo "Percobaan login terakhir:" | tee -a /tmp/last.login
date | tee -a /tmp/last.login
# Catat pula status percobaan login terakhir
echo "Status percobaan login terakhir:" | tee -a  /tmp/last.login
# Dan lakukan login, serta catat semua hasilnya di berkas /tmp/last.login untuk pengecekan
$loginwifi | jsonfilter -e '@["message"]' | tee -a /tmp/internet.status /tmp/last.login | logger
fi

# Istirahat selama 10 detik sebelum melakukan pengecekan lagi
sleep 10
# Selesai
done
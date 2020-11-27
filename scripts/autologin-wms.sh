#!/bin/sh
#
# Script untuk login otomatis di jaringan venue WMS
# Oleh: KopiJahe (https://github.com/kopijahe)

# Jika digunakan untuk Load-Balance,
# bagian di bawah baris ini bisa diubah sesuai kebutuhan
# ===================================================

# Jika digunakan untuk load-balance, rubah baris di bawah menjadi LB=ON
LB=OFF

# Tentukan lokasi berkas login_file.txt
# Jangan lupa untuk berikan izin eksekusi berkas dengan perintah:
# chmod +x /etc/login_file.txt
filelogintxtwms=/etc/login_file.txt
# Tentukan lokasi berkas sementara
loginwms=/tmp/login_file.txt

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

# Jika tidak digunakan untuk Load-Balance, maka:
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

# Tentukan variabel status dari hasil unduhan berkas
# dari: http://periksakoneksi.kopijahe.my.id/cek
# dan simpan hasilnya di stdout
status=$(curl --interface $radiointerface --silent --max-redirs 1 --retry 5 --connect-timeout 10  "http://periksakoneksi.kopijahe.my.id/cek")
# Jika variabel status hasil unduhan tadi sama dengan "OK", maka
if [[ "$status" = "OK" ]]; then
# Beritahu pengguna bahwa sudah terkoneksi dengan Internet
# Dan simpan hasilnya di /tmp/internet.status.wms untuk pengecekan
echo "Sudah terkoneksi dengan Internet" | tee /tmp/internet.status.wms
# Jika hasilnya tidak sama, berarti tidak terkoneksi dengan Internet, maka:
else
# Gandakan berkas login_file.txt ke lokasi berkas sementara
cp $filelogintxtwms $loginwms
# Buat variabel randomid yang terdiri dari 4 karakter angka dan huruf acak
# Hal ini diperlukan karena sistem login WMS menambahkan 4 karakter acak
# Setelah username pengguna setiap kali login
randomid=$(head -4 /dev/urandom | tr -dc "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" | head -c4)
# Masukkan hasil randomid ke berkas sementara
sed -i "s/kopijahe/$randomid/g" $loginwms
#Buat variabel iprouter dengan mengambil ip terbaru dari variabel waninterface
iprouter=$(ifstatus $waninterface |  jsonfilter -e '@["ipv4-address"][0].address')
# Sesuaikan alamat IP dengan versi terbaru dari variabel iprouter
sed -i "s/iprouter/$iprouter/g" $loginwms
# Sesuaikan interface yang akan digunakan dengan variabel radiointerface
sed -i "s/curl/curl --interface $radiointerface/g" $loginwms
# Beri izin eksekusi berkas sementara
chmod +x $loginwms
# Catat tanggal dan jam login terakhir,
echo "Percobaan login terakhir:" | tee /tmp/last.login.wms
date | tee -a /tmp/last.login.wms
# Catat pula status percobaan login terakhir
echo "Status percobaan login terakhir:" | tee -a  /tmp/last.login.wms
# Dan lakukan login, serta catat semua hasilnya di berkas /tmp/last.login.wms untuk pengecekan
$loginwms | jsonfilter -e '@["message"]' | tee -a /tmp/internet.status.wms /tmp/last.login.wms | logger
fi
# Istirahat selama 10 detik sebelum melakukan pengecekan lagi
sleep 10
# Selesai
done
#!/bin/sh
#
# Script untuk login otomatis di jaringan wifi.id
# Oleh: KopiJahe (https://github.com/kopijahe)
#
# Varian ini juga mengecek apakah IP terblokir
# atau tidak, agar proses autologin tetap berjalan mulus
#
# Tentukan lokasi berkas login_file.txt
# Jangan lupa untuk berikan izin eksekusi berkas dengan perintah:
# chmod +x /etc/login_file.txt
filelogintxt=/etc/login_file.txt
# Tentukan lokasi berkas sementara
loginwifi=/tmp/login_file.txt

# Tentukan interface yang digunakan untuk menangkap sinyal wifi.id secara otomatis
# Jika digunakan untuk load-balance, rubah baris di bawah menjadi LB=ON
LB=OFF
if [[ "$LB" = "OFF" ]]; then
# Muat library network OpenWrt
. /lib/functions/network.sh
# Bersihkan cache terlebih dahulu
network_flush_cache
# Cari interface jaringan WAN yang digunakan
# untuk koneksi ke jaringan wifi.id
# dan simpan hasilnya di variabel waninterface
network_find_wan waninterface
else
# Jika digunakan untuk load-balance,
# Maka tentukan variabel waninterface secara manual
# Sesuai dengan interface yang digunakan (misal: wwan2)
waninterface=wwan
fi

# Tentukan lokasi perangkat radio waninterface (misal: wlan0 atau wlan1)
radiointerface=$(ifstatus $waninterface | jsonfilter -e '@["device"]')

# Selama script berjalan, lakukan hal ini:
while [ true ]; do

# Tentukan variabel ipblocked
# untuk berjaga-jaga jika IP terblokir
# karena terlalu cepat dalam autologin

ipblocked=$(cat /tmp/last.login | grep -o "Blocked IP")

# Cek apakah berkas ini tersedia atau tidak
# dengan batasan redirect 1 kali:
# http://connectivitycheck.google.com/generate_204
# dan simpan hasilnya di stdout supaya tidak memakan tempat penyimpanan
status=$(curl --interface $radiointerface --silent --max-redirs 1 --connect-timeout 10 -LI "http://connectivitycheck.gstatic.com/generate_204" | grep -o "204")
# Jika respon dari server adalah "HTTP/1.1 204 No Content", maka:
if [[ "$status" = "204" ]]; then
# Beritahu pengguna bahwa sudah terkoneksi dengan Internet
# Dan simpan hasilnya di /tmp/internet.status untuk pengecekan
echo "Sudah terkoneksi dengan Internet" | tee /tmp/internet.status
# Jika hasilnya tidak sama, berarti tidak terkoneksi dengan Internet, maka:
#
# Cek terlebih dahulu apakah IP terblokir?
elif [[ "$ipblocked" = "Blocked IP" ]]; then
# Jika terblokir, maka:
# Beritahu pengguna bahwa IP terblokir
echo "Status IP: Terblokir" | tee /tmp/last.login
# Cari tahu PID dari proses udhcpc koneksi yang terblokir
udhcpcpid=$(cat /var/run/udhcpc-$radiointerface.pid)
# Dan minta penggantian IP ke server
kill -SIGUSR2 $udhcpcpid && ifup $waninterface
# Istirahat selama 20 detik sambil menunggu koneksi
sleep 20
# Gandakan berkas login_file.txt ke lokasi berkas sementara
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
else
# Jika IP tidak terblokir, maka:
# Beritahu pengguna bahwa IP tidak terblokir
echo "Status IP: Tidak terblokir" | tee /tmp/last.login
# Gandakan berkas login_file.txt ke lokasi berkas sementara
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
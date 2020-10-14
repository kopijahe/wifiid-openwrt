#!/bin/sh
#
# Script untuk login otomatis di jaringan wifi.id
# Oleh: KopiJahe (https://github.com/kopijahe)
#
# Varian ini juga mengecek apakah IP terblokir
# atau tidak, agar proses autologin tetap berjalan mulus
#
# Tentukan variabel loginwifi dari berkas /etc/login_file.txt
# Jangan lupa untuk berikan izin eksekusi berkas dengan perintah:
# chmod +x /etc/login_file.txt

loginwifi=/etc/login_file.txt

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
status=$(curl --silent --max-redirs 1 --connect-timeout 10 -LI "http://connectivitycheck.gstatic.com/generate_204" | grep -o "204")
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
# Dan minta penggantian IP ke server
killall -SIGUSR2 udhcpc && ifup wwan
# Istirahat selama 20 detik sambil menunggu koneksi
sleep 20
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
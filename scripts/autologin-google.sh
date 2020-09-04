#!/bin/sh
#
# Script untuk login otomatis di jaringan wifi.id
# Oleh: KopiJahe (https://github.com/kopijahe)
#
# Varian ini membutuhkan paket wget terpisah
# agar bisa mendeteksi redirect ke halaman login.
# Jangan lupa untuk memasang paketnya dengan perintah:
# opkg update && opkg install wget
#
# Tentukan variabel loginwifi dari berkas /etc/login_file.txt
# Jangan lupa untuk berikan izin eksekusi berkas dengan perintah:
# chmod +x /etc/login_file.txt

loginwifi=/etc/login_file.txt

# Selama script berjalan, lakukan hal ini:
while [ true ]; do
# Cek apakah berkas ini tersedia atau tidak
# dengan batasan redirect 1 kali:
# http://connectivitycheck.google.com/generate_204
# dan simpan hasilnya di /dev/null supaya tidak memakan tempat penyimpanan
/usr/bin/wget -q --spider --max-redirect=1 http://connectivitycheck.gstatic.com/generate_204 > /dev/null
# Jika tidak terdapat error (kode 0), maka:
if [[ $? -eq 0 ]]; then
# Beritahu pengguna bahwa sudah terkoneksi dengan Internet
# Dan simpan hasilnya di /tmp/internet.status untuk pengecekan
echo "Sudah terkoneksi dengan Internet" | tee /tmp/internet.status
# Jika terdapat error (kode bukan 0), berarti tidak terkoneksi dengan Internet, maka:
else
# Catat tanggal dan jam login terakhir,
echo "Percobaan login terakhir:" | tee /tmp/last.login
date | tee -a /tmp/last.login
# Catat pula status percobaan login terakhir
echo "Status percobaan login terakhir:" | tee -a  /tmp/last.login
# Dan lakukan login, serta catat semua hasilnya di berkas /tmp/last.login untuk pengecekan
$loginwifi | tee -a /tmp/internet.status /tmp/last.login | logger
fi
# Istirahat selama 10 detik sebelum melakukan pengecekan lagi
sleep 10
# Selesai
done
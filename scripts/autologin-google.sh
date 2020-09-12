#!/bin/sh
#
# Script untuk login otomatis di jaringan wifi.id
# Oleh: KopiJahe (https://github.com/kopijahe)
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
# dan simpan hasilnya di stdout supaya tidak memakan tempat penyimpanan
status=$(curl --silent --max-redirs 1 --connect-timeout 10 -LI "http://connectivitycheck.gstatic.com/generate_204" | grep -o "204")
# Jika respon dari server adalah "HTTP/1.1 204 No Content", maka:
if [[ "$status" = "204" ]]; then
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
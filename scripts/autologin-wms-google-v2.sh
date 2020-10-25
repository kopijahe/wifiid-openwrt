#!/bin/sh
#
# Script untuk login otomatis di jaringan venue WMS
# Oleh: KopiJahe (https://github.com/kopijahe)

# Varian ini juga mengecek apakah IP terblokir
# atau tidak, agar proses autologin tetap berjalan mulus

# Tentukan lokasi berkas login_file.txt
filelogintxt=/etc/login_file.txt
# Tentukan lokasi berkas sementara
loginwms=/tmp/login_file.txt

# Tentukan interface yang digunakan untuk menangkap sinyal WMS secara otomatis
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
waninterface=wwan2
fi

# Tentukan lokasi perangkat radio waninterface (misal: wlan0 atau wlan1)
radiointerface=$(ifstatus $waninterface | jsonfilter -e '@["device"]')

# Selama script berjalan, lakukan hal ini:
while [ true ]; do
# Tentukan variabel gagallogin
# untuk berjaga-jaga jika gagal login
gagallogin=$(cat /tmp/last.login.wms | grep -o "Gagal Login")
# Cek apakah berkas ini tersedia atau tidak
# dengan batasan redirect 1 kali:
# http://connectivitycheck.google.com/generate_204
# dan simpan hasilnya di stdout supaya tidak memakan tempat penyimpanan
status=$(curl --interface $radiointerface --silent --max-redirs 1 --connect-timeout 10 -LI "http://connectivitycheck.gstatic.com/generate_204" | grep -o "204")
# Jika respon dari server adalah "HTTP/1.1 204 No Content", maka:
if [[ "$status" = "204" ]]; then
# Beritahu pengguna bahwa sudah terkoneksi dengan Internet
# Dan simpan hasilnya di /tmp/internet.status.wms untuk pengecekan
echo "WMS sudah terkoneksi dengan Internet" | tee /tmp/internet.status.wms
# Jika hasilnya tidak sama, berarti tidak terkoneksi dengan Internet, maka:
# Cek dulu apakah hasil unduhan kosong ("koneksi bengong") ataukah ada gagal login?
elif [[ "$status" = "" ]] || [[ "$gagallogin" = "Gagal Login" ]]; then
# Beritahu koneksi dengan Internet terputus
echo "Koneksi dengan Internet terputus" | tee /tmp/last.login
# Dan mulai proses penggantian alamat IP
echo "Minta penggantian alamat IP ke server" | tee /tmp/last.login
# Cari tahu PID dari proses udhcpc koneksi yang terblokir
udhcpcpid=$(cat /var/run/udhcpc-$radiointerface.pid)
# Dan minta penggantian IP ke server
kill -SIGUSR2 $udhcpcpid && ifup $waninterface
# Istirahat selama 20 detik sambil menunggu koneksi
sleep 20
# Gandakan berkas login_file.txt ke lokasi berkas sementara
cp $filelogintxt $loginwms
#Buat variabel iprouter dengan mengambil ip terbaru dari variabel waninterface
iprouter=$(ifstatus $waninterface |  jsonfilter -e '@["ipv4-address"][0].address')
# Sesuaikan alamat IP dengan versi terbaru dari variabel iprouter
sed -i "s/iprouter/$iprouter/g" $loginwms
# Sesuaikan interface yang akan digunakan dengan variable radiointerface
sed -i "s/curl/curl --interface $radiointerface/g" $loginwms
# Beri izin eksekusi berkas sementara
chmod +x $loginwms
# Catat tanggal dan jam login terakhir,
echo "Percobaan login terakhir:" | tee -a /tmp/last.login
date | tee -a /tmp/last.login
# Catat pula status percobaan login terakhir
echo "Status percobaan login terakhir:" | tee -a  /tmp/last.login
# Dan lakukan login, serta catat semua hasilnya di berkas /tmp/last.login untuk pengecekan
$loginwwms | jsonfilter -e '@["message"]' | tee -a /tmp/internet.status /tmp/last.login | logger
# Jika hasil unduhan tidak kosong, maka:
# Cek terlebih dahulu apakah IP terblokir?
else
# Gandakan berkas login_file.txt ke lokasi berkas sementara
cp "$filelogintxt" "$loginwms"
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
#!/bin/sh
#
while [ true ]; do
status=$(wget -q --timeout 10 http://periksakoneksi.kopijahe.my.id/cek -O -)
if [[ $status = "OK" ]]; then
echo "Connected to the internet" | tee /tmp/internet.status
else
echo "Last login attempt:" | tee /tmp/last.login
date | tee -a /tmp/last.login
echo "Login attempt status:" | tee -a  /tmp/last.login
curl <paste output curl> | tee -a /tmp/internet.status /tmp/last.login | logger
fi
sleep 10
done

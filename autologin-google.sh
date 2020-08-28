#!/bin/sh
#
while [ true ]; do
/usr/bin/wget -q --spider --max-redirect=1 http://connectivitycheck.gstatic.com/generate_204 > /dev/null
if [[ $? -eq 0 ]]; then
echo "Connected to the internet" | tee /tmp/internet.status
else
echo "Last login attempt:" | tee /tmp/last.login
date | tee -a /tmp/last.login
echo "Login attempt status:" | tee -a  /tmp/last.login
curl <paste output curl> | tee -a /tmp/internet.status /tmp/last.login | logger
fi
sleep 10
done

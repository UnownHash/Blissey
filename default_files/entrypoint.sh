#!/bin/sh
env >> /etc/environment

# run blissy settings.run
cd /blissey
./settings.run >> /blissey/logs/settings_run.log

# set crontab file
echo "SHELL=/bin/bash" > /etc/crontab
cat /blissey/crontab.txt >> /etc/crontab
sed -i "s,cd,root cd,g" /etc/crontab

# execute CMD
echo "$@"
exec "$@"
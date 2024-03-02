#!/bin/sh
env >> /etc/environment

# run blissy settings.run
cd /blissey
./settings.run >> /blissey/logs/settings_run.log

# set crontab file
cat /blissey/crontab.txt > /etc/crontabs/root

# execute CMD
echo "$@"
exec "$@"
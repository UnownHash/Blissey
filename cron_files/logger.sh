#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log
echo " " >> $folder/logs/log_$(date '+%Y%m').log
echo "#########################          $(date '+%Y-%m-%d')           #########################" >> $folder/logs/log_$(date '+%Y%m').log
echo "Start time          Stop time           Duration  Process" >> $folder/logs/log_$(date '+%Y%m').log

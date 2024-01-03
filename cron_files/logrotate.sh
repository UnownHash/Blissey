#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rotate drago log
if "$dragonitelog"
then
  start=$(date '+%Y%m%d %H:%M:%S')
#  curl -s -k -L --fail --show-error http://$dragonite_api_host:$dragonite_api_port/logrotate
  result=$(curl -s -o /dev/null -w "%{http_code}" http://$dragonite_api_host:$dragonite_api_port/logrotate)
  if [[ $result != 202 ]] ;then
    curl -s -k -L --fail --show-error http://$dragonite_api_host:$dragonite_api_port/log-rotate
  fi
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] drago log rotation requested" >> $folder/logs/log_$(date '+%Y%m').log
fi

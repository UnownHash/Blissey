#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log


# table cleanup golbat pokemon_area_stats
if [[ ! -z $area_raw ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -h$dbip -P$dbport -u$sqluser $scannerdb -e "delete from pokemon_area_stats where datetime < UNIX_TIMESTAMP(now() - interval $area_raw day);"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup golbat table pokemon_area_stats" >> $folder/logs/log_$(date '+%Y%m').log
fi

# table cleanup controller stats_workers
if [[ ! -z $worker_raw ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $controllerdb -e "delete from stats_workers where datetime < utc_timestamp() - interval $worker_raw day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup controller table stats_workers" >> $folder/logs/log_$(date '+%Y%m').log
fi

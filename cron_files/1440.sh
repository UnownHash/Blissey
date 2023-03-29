#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rpl 1440 worker stats
if "$workerstats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/1440_worker.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 worker stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

## backup golbat db
if "$golbat_backup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  mkdir -p $folder/golbatbackup
  MYSQL_PWD=$sqlpass mysqldump -u$sqluser -h$dbip -P$dbport --no-data --routines $scannerdb > $folder/golbatbackup/golbatbackup_$(date +%Y-%m-%d).sql
  MYSQL_PWD=$sqlpass mysqldump -u$sqluser -h$dbip -P$dbport $scannerdb gym pokestop spawnpoint schema_migrations >> $folder/golbatbackup/golbatbackup_$(date +%Y-%m-%d).sql
  cd $folder/golbatbackup && tar --remove-files -czvf golbatbackup_$(date +%Y-%m-%d).sql.tar.gz golbatbackup_$(date +%Y-%m-%d).sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] daily golbat backup" >> $folder/logs/log_$(date '+%Y%m').log
fi
## golbat db backup cleanup
if "$golbat_backup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  find $folder/golbatbackup -type f -mtime +$golbat_backup_days -exec rm -f {} \;
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] daily golbat backup cleanup" >> $folder/logs/log_$(date '+%Y%m').log
fi

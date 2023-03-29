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

# rpl 1440 mon area stats
if "$monareastats"
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/1440_mon_area.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 mon area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 1440 quest area stats
if "$questareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/1440_quest_area.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 quest area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 1440 spawnpoint area stats
if "$spawnpointareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/1440_spawnpoint_area.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 spawnpoint area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
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


## Cleanup stats tables
if [[ ! -z $blissey_rpl15 ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 15 and datetime < now() - interval $blissey_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 60 and datetime < now() - interval $blissey_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 1440 and datetime < now() - interval $blissey_rpl1440 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 10080 and datetime < now() - interval $blissey_rpl10080 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 15 and datetime < now() - interval $blissey_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 60 and datetime < now() - interval $blissey_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 1440 and datetime < now() - interval $blissey_rpl1440 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 10080 and datetime < now() - interval $blissey_rpl10080 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 15 and datetime < now() - interval $blissey_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 60 and datetime < now() - interval $blissey_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 1440 and datetime < now() - interval $blissey_rpl1440 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 10080 and datetime < now() - interval $blissey_rpl10080 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_spawnpoint where rpl = 15 and datetime < now() - interval $blissey_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_spawnpoint where rpl = 60 and datetime < now() - interval $blissey_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_spawnpoint where rpl = 1440 and datetime < now() - interval $blissey_rpl1440 day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup stats tables" >> $folder/logs/log_$(date '+%Y%m').log
fi


## Cleaup unseen spawnpoints
if [[ ! -z spawn_delete_days ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $scannerdb -e "delete from spawnpoint where last_seen < (unix_timestamp() - ($spawn_delete_days*86400));"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] remove spawnpoints unseen for $spawn_delete_days days" >> $folder/logs/log_$(date '+%Y%m').log
fi

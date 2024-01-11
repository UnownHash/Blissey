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
then
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

# rpl 14400 fortwatcher stats
if "$fortwatcher"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/1440_fortwatcher.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 fortwatcher stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# Daily aggregation Dragonite logs
if [[ $dragonitelog == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/1440_dragonite.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 dragonite log processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 1440 fort log processing
if [[ $dragonitelog == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/1440_fort.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl1440 fort log processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

## backup golbat db
if "$golbat_backup"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  mkdir -p $folder/golbatbackup
  if [[ -z $golbat_host ]] ;then
    MYSQL_PWD=$sqlpass mysqldump -u$sqluser -h$dbip -P$dbport --no-data --routines $scannerdb > $folder/golbatbackup/golbatbackup_$(date +%Y-%m-%d).sql
    MYSQL_PWD=$sqlpass mysqldump -u$sqluser -h$dbip -P$dbport $scannerdb gym pokestop spawnpoint schema_migrations >> $folder/golbatbackup/golbatbackup_$(date +%Y-%m-%d).sql
  else
    MYSQL_PWD=$sqlpass mysqldump -u$sqluser -h$golbat_host -P$dbport --no-data --routines $scannerdb > $folder/golbatbackup/golbatbackup_$(date +%Y-%m-%d).sql
    MYSQL_PWD=$sqlpass mysqldump -u$sqluser -h$golbat_host -P$dbport $scannerdb gym pokestop spawnpoint schema_migrations >> $folder/golbatbackup/golbatbackup_$(date +%Y-%m-%d).sql
  fi
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

## backup dragonite db
if [[ $drago_backup == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  mkdir -p $folder/dragobackup
  MYSQL_PWD=$sqlpass mysqldump -u$sqluser -h$dbip -P$dbport $dragonitedb > $folder/dragobackup/dragobackup_$(date +%Y-%m-%d).sql
  cd $folder/dragobackup && tar --remove-files -czvf dragobackup_$(date +%Y-%m-%d).sql.tar.gz dragobackup_$(date +%Y-%m-%d).sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] daily dragonite backup" >> $folder/logs/log_$(date '+%Y%m').log
fi
## dragonite db backup cleanup
if [[ $drago_backup == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  find $folder/dragobackup -type f -mtime +$drago_backup_days -exec rm -f {} \;
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] daily dragonite backup cleanup" >> $folder/logs/log_$(date '+%Y%m').log
fi


## Cleanup stats tables
if [[ ! -z $blissey_rpl15 ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  if [[ $workerstats == "true" ]] ;then
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 5 and datetime < now() - interval $blissey_rpl5 day;"
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 15 and datetime < now() - interval $blissey_rpl15 day;"
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 60 and datetime < now() - interval $blissey_rpl60 day;"
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 1440 and datetime < now() - interval $blissey_rpl1440 day;"
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_worker where rpl = 10080 and datetime < now() - interval $blissey_rpl10080 day;"
  fi
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 5 and datetime < now() - interval $blissey_rpl5 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 15 and datetime < now() - interval $blissey_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 60 and datetime < now() - interval $blissey_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 1440 and datetime < now() - interval $blissey_rpl1440 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_mon_area where rpl = 10080 and datetime < now() - interval $blissey_rpl10080 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 5 and datetime < now() - interval $blissey_rpl5 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 15 and datetime < now() - interval $blissey_rpl15 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 60 and datetime < now() - interval $blissey_rpl60 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 1440 and datetime < now() - interval $blissey_rpl1440 day;"
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_quest_area where rpl = 10080 and datetime < now() - interval $blissey_rpl10080 day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup stats tables" >> $folder/logs/log_$(date '+%Y%m').log
fi

# cleanup accounts
if [[ ! -z $accounts_rpl15 ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from accounts where rpl = 15 and datetime < now() - interval $accounts_rpl15 day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup table accounts" >> $folder/logs/log_$(date '+%Y%m').log
fi

# cleanup stats_account
if [[ ! -z $account_stats ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "delete from stats_account where datetime < now() - interval $account_stats day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup table stats_account" >> $folder/logs/log_$(date '+%Y%m').log
fi

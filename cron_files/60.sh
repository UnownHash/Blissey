#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rpl 60 worker stats
if "$workerstats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/60_worker.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl60 worker stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 60 mon area stats
if "$monareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/60_mon_area.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl60 mon area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 60 quest area stats
if "$questareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/60_quest_area.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl60 quest area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 60 fortwatcher stats
if "$fortwatcher"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/60_fortwatcher.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl60 fortwatcher stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 60 dragonite log processing
if [[ $dragonitelog == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/60_dragonite.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl60 drago log processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 60 fort log processing
if [[ $dragonitelog == "true" ]]
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/default_files/60_fort.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl60 fort log processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

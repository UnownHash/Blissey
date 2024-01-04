#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

# Logging
mkdir -p $folder/logs
touch $folder/logs/log_$(date '+%Y%m').log

# stderr to logfile
exec 2>> $folder/logs/log_$(date '+%Y%m').log

# rpl 5 worker stats
if "$workerstats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $controllerdb < $folder/cron_files/5_worker.sql
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl5 worker stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 5 mon area stats
if "$monareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  if [[ -z $golbat_host ]] ;then
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/cron_files/5_mon_area.sql
  else
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$golbat_host $scannerdb < $folder/cron_files/5_mon_area_external.sql | grep "('2" > $folder/tmp/golbat.sql
    sed -i '$s/.$/;/' $folder/tmp/golbat.sql
    sed -i "1 i\insert ignore into $blisseydb.stats_mon_area (datetime,rpl,area,fence,totMon,ivMon,verifiedEnc,unverifiedEnc,verifiedReEnc,encSecLeft,encTthMax5,encTth5to10,encTth10to15,encTth15to20,encTth20to25,encTth25to30,encTth30to35,encTth35to40,encTth40to45,encTth45to50,encTth50to55,encTthMin55,resetMon,re_encSecLeft,numWiEnc,secWiEnc) values" $folder/tmp/golbat.sql
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/tmp/golbat.sql
    rm $folder/tmp/golbat.sql
  fi
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl5 mon area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# rpl 5 quest area stats
if "$questareastats"
then
  start=$(date '+%Y%m%d %H:%M:%S')
  if [[ -z $golbat_host ]] ;then
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -NB -e "SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; call rpl5questarea();"
  else
    if [[ $use_koji == "true" ]] ;then
      MYSQL_PWD=$sqlpass mysql -u$sqluser -h$golbat_host -P$dbport $scannerdb -NB -e "SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; call rpl5questarea();" > $folder/tmp/quest.sql
    else
      MYSQL_PWD=$sqlpass mysql -u$sqluser -h$golbat_host -P$dbport $scannerdb -NB -e "SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; create temporary table areas (id int NOT NULL,area varchar(40) NOT NULL,fence varchar(40) NOT NULL,coords text NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci; LOAD DATA LOCAL INFILE '$folder/cron_files/questfences.txt' INTO table areas FIELDS TERMINATED BY '\|'; call rpl5questarea();" > $folder/tmp/quest.sql
    fi
    sed -i '$s/.$/;/' $folder/tmp/quest.sql
    sed -i "1 i\insert ignore into $blisseydb.stats_quest_area (datetime,rpl,area,fence,stops,AR,nonAR,ARcum,nonARcum) values" $folder/tmp/quest.sql
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb < $folder/tmp/quest.sql
    rm $folder/tmp/quest.sql
  fi
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] rpl5 quest area stats processing" >> $folder/logs/log_$(date '+%Y%m').log
fi

# device outage reporting
if [[ $outage_report == "true" ]] && [[ ! -z $outage_webhook ]]
then
  rm -f $folder/tmp/outage.txt
  curl -s $rotom_api_host:$rotom_api_port/api/status | jq -r '.devices[] | .origin+" "+(.dateLastMessageReceived|tostring)' | awk '{ if($2 <= systime()*1000-180000) print $1" "strftime("%Y%m%d_%H:%M:%S", $2/1000)}' > $folder/tmp/outage.txt
  cd $folder/default_files && ./discord.sh --username "Containers, no update in 3m" --color "16711680" --avatar "https://www.iconsdb.com/icons/preview/red/exclamation-xxl.png" --webhook-url "$outage_webhook" --description "$(jq -Rs . < "$folder/tmp/outage.txt" | cut -c 2- | rev | cut -c 2- | rev)"
fi

# rpl 5 dragonite log processing
if [[ $dragonitelog == "true" ]]
then
  cd $folder/cron_files && ./5_dragonitelog.sh
#  sleep 1s
  cd $folder/cron_files && ./5_accountstats.sh
#  sleep 1s
  cd $folder/cron_files && ./5_forts.sh
fi

# table cleanup golbat pokemon_area_stats
if [[ ! -z $area_raw ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  if [[ -z $golbat_host ]] ;then
    MYSQL_PWD=$sqlpass mysql -h$dbip -P$dbport -u$sqluser $scannerdb -e "delete from pokemon_area_stats where datetime < UNIX_TIMESTAMP(now() - interval $area_raw day);"
  else
    MYSQL_PWD=$sqlpass mysql -h$golbat_host -P$dbport -u$sqluser $scannerdb -e "delete from pokemon_area_stats where datetime < UNIX_TIMESTAMP(now() - interval $area_raw day);"
  fi
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup golbat table pokemon_area_stats" >> $folder/logs/log_$(date '+%Y%m').log
fi

# table cleanup controller stats_workers
if [[ ! -z $worker_raw ]] && [[ $workerstats == "true" ]] ;then
  start=$(date '+%Y%m%d %H:%M:%S')
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $controllerdb -e "delete from stats_workers where datetime < utc_timestamp() - interval $worker_raw day;"
  stop=$(date '+%Y%m%d %H:%M:%S')
  diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
  echo "[$start] [$stop] [$diff] cleanup controller table stats_workers" >> $folder/logs/log_$(date '+%Y%m').log
fi

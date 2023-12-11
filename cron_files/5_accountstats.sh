#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

if ! "$dragonitelog"
then
  exit
fi

plog=$folder/tmp/d2_interval.log

# Logging prep
start=$(date '+%Y%m%d %H:%M:%S')

if [[ -f $plog ]] ;then
# get data

while read -r line ;do
  datetime=$(echo $line | awk '{ print $2,$3}')
  worker=$(echo $line | awk '{ print $4}' | sed 's/\[//g' | sed 's/\]//g')
  account=$(echo $line | awk '{ print $6}')
  DISK_ENCOUNTER=$(echo $line | grep -oP '(?<=METHOD_DISK_ENCOUNTER: )[0-9]+')
  GET_HOLOHOLO_INVENTORY=$(echo $line | grep -oP '(?<=METHOD_GET_HOLOHOLO_INVENTORY: )[0-9]+')
  GET_PLAYER=$(echo $line | grep -oP '(?<=METHOD_GET_PLAYER: )[0-9]+')
  GET_MAP_OBJECTS=$(echo $line | grep -oP '(?<=METHOD_GET_MAP_OBJECTS: )[0-9]+')
  ENCOUNTER=$(echo $line | grep -oP '(?<=METHOD_ENCOUNTER: )[0-9]+')
  FORT_DETAILS=$(echo $line | grep -oP '(?<=METHOD_FORT_DETAILS: )[0-9]+')
  GYM_GET_INFO=$(echo $line | grep -oP '(?<=METHOD_GYM_GET_INFO: )[0-9]+')
  RECYCLE_INVENTORY_ITEM=$(echo $line | grep -oP '(?<=METHOD_RECYCLE_INVENTORY_ITEM: )[0-9]+')
  REMOVE_QUEST=$(echo $line | grep -oP '(?<=METHOD_REMOVE_QUEST: )[0-9]+')
  FORT_SEARCH=$(echo $line | grep -oP '(?<=METHOD_FORT_SEARCH: )[0-9]+')
  GET_RAID_LOBBY_COUNTER=$(echo $line | grep -oP '(?<=METHOD_GET_RAID_LOBBY_COUNTER: )[0-9]+')
  duration=$(echo $line | awk '{print $(NF-1)}' | sed 's/\[//g')

  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into stats_account (datetime,worker,account,DISK_ENCOUNTER,GET_HOLOHOLO_INVENTORY,GET_PLAYER,GET_MAP_OBJECTS,ENCOUNTER,FORT_DETAILS,GYM_GET_INFO,RECYCLE_INVENTORY_ITEM,REMOVE_QUEST,FORT_SEARCH,GET_RAID_LOBBY_COUNTER,duration) values ('$datetime','$worker','$account','$DISK_ENCOUNTER','$GET_HOLOHOLO_INVENTORY','$GET_PLAYER','$GET_MAP_OBJECTS','$ENCOUNTER','$FORT_DETAILS','$GYM_GET_INFO','$RECYCLE_INVENTORY_ITEM','$REMOVE_QUEST','$FORT_SEARCH','$GET_RAID_LOBBY_COUNTER','$duration');"

done < <(grep 'Request counts' $plog)

else
  echo "No interval log found to process ($plog)" >> $folder/logs/log_$(date '+%Y%m').log
fi

echo ""
# add logline
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] rpl5 dragonite log account stats processing" >> $folder/logs/log_$(date '+%Y%m').log
echo "All done!"

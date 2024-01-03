#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

if ! "$dragonitelog"
then
  exit
fi

process_time=$(date -d '5 minute ago' +%Y"-"%m"-"%d" "%H":"%M":00")
plog=$folder/tmp/d2_interval.log

# Logging prep
startt=$(date '+%Y%m%d %H:%M:%S')

if [[ -f $plog ]] ;then

# exit when no fort area name is set
  if [[ -z $fort_area_name ]] ;then exit ;fi

# allow for fort area workers array
  if [[ $fort_area_name != "dkmurisanidiot" ]] ;then
    counter=0
    for i in ${fort_area_name[@]} ;do
      counter=$(( counter + 1 ))
      if (( $counter == 1 )) ;then new="\\[${i}_" ;else new="${new}\\|\\[${i}_" ;fi
   done
  fort_area_name=$new
  fi

# process workers
  for worker in $(zgrep ${fort_area_name} $plog | awk '{print $4}' | sort | uniq | sed 's/\[/\\\[/g' | sed 's/\]/\\\]/g') ;do
    name=$(echo $worker | sed 's/\\\[//g' | sed 's/\\\]//g')
    fetchRaid=$(zgrep $worker $plog | grep 'Fetching raids around' | wc -l)
    modeLocations=$(zgrep $worker $plog | grep 'Moving to' | wc -l)
#    gotGMO=$(zgrep $worker $plog | grep 'Got a GMO: .* cells' | grep -v 'Got a GMO: 0 cells' | wc -l)
    fortLookup=$(zgrep $worker $plog | grep 'Waiting for .* fort lookups to complet' | awk '{print $7}' | jq -s add)
    totalProtoTimeFort=$(zgrep $worker $plog | grep 'location time elapsed' | grep -v 'RAIDWATCHER' | awk '{print $10}' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s add)
    totalProtoTimeRaid=$(zgrep $worker $plog | grep 'location time elapsed' | grep 'RAIDWATCHER' | awk '{print $9}' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s add)
#echo $name fetchRaidLocation:$fetchRaid Locations:$modeLocations gotGMO:$gotGMO fortLookups:$fortLookup totalProtoTimeFort:$totalProtoTimeFort totalProtoTimeRaid:$totalProtoTimeRaid
# insert data
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into stats_worker_fort (datetime,rpl,worker,fetchRaid,modeLocations,fortLookup,totalProtoTimeFort,totalProtoTimeRaid) values ('$process_time',5,'$name','$fetchRaid','$modeLocations','$fortLookup','$totalProtoTimeFort','$totalProtoTimeRaid');"
  done

# process prio raid
  scanCount=$(zgrep -c 'RAIDWATCHER.*Raid at gym.*pokemon discovered egg popped' $plog)
  if [[ $scanCount == 0 ]] ;then
    scanMin=0
    scanMax=0
    scanAvg=0
    raidMin=0
    raidMax=0
    raidAvg=0
  else
    scanMin=$(zgrep 'RAIDWATCHER:.*Raid at gym.*pokemon discovered egg popped' $plog | awk '{print $19}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s min)
    scanMax=$(zgrep 'RAIDWATCHER:.*Raid at gym.*pokemon discovered egg popped' $plog | awk '{print $19}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s max)
    scanAvg=$(zgrep 'RAIDWATCHER:.*Raid at gym.*pokemon discovered egg popped' $plog | awk '{print $19}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s add/length)
    raidMin=$(zgrep 'RAIDWATCHER:.*Raid at gym.*pokemon discovered egg popped' $plog | awk '{print $26}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s min)
    raidMax=$(zgrep 'RAIDWATCHER:.*Raid at gym.*pokemon discovered egg popped' $plog | awk '{print $26}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s max)
    raidAvg=$(zgrep 'RAIDWATCHER:.*Raid at gym.*pokemon discovered egg popped' $plog | awk '{print $26}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s add/length)
  fi
  Qcount=$(zgrep -c 'RAIDWATCHER:.*raids in queue' $plog)
  if [[ $Qcount == 0 ]] ;then
    raidActiveMin=0
    raidActiveMax=0
    raidActiveAvg=0
    raidQueueMin=0
    raidQueueMax=0
    raidQueueAvg=0
  else
    raidActiveMin=$(zgrep 'RAIDWATCHER:.*raids in queue' $plog | awk '{print $11}' | sed 's/\[//g' | jq -s min)
    raidActiveMax=$(zgrep 'RAIDWATCHER:.*raids in queue' $plog | awk '{print $11}' | sed 's/\[//g' | jq -s max)
    raidActiveAvg=$(zgrep 'RAIDWATCHER:.*raids in queue' $plog | awk '{print $11}' | sed 's/\[//g' | jq -s add/length)
    raidQueueMin=$(zgrep 'RAIDWATCHER:.*raids in queue' $plog | awk '{print $7}' | jq -s min)
    raidQueueMax=$(zgrep 'RAIDWATCHER:.*raids in queue' $plog | awk '{print $7}' | jq -s max)
    raidQueueAvg=$(zgrep 'RAIDWATCHER:.*raids in queue' $plog | awk '{print $7}' | jq -s add/length)
  fi
# insert data
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into stats_prioraid (datetime,rpl,scanCount,scanMin,scanMax,scanAvg,raidMin,raidMax,raidAvg,raidActiveMin,raidActiveMax,raidActiveAvg,raidQueueMin,raidQueueMax,raidQueueAvg,Qcount) values ('$process_time',5,'$scanCount','$scanMin','$scanMax','$scanAvg','$raidMin','$raidMax','$raidAvg','$raidActiveMin','$raidActiveMax','$raidActiveAvg','$raidQueueMin','$raidQueueMax','$raidQueueAvg','$Qcount');"

else
  echo "No interval log found to process ($plog)" >> $folder/logs/log_$(date '+%Y%m').log
fi

# add logline
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$startt" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$startt" +%s)))%60)))
echo "[$startt] [$stop] [$diff] rpl5 fort log processing" >> $folder/logs/log_$(date '+%Y%m').log
echo "All done!"

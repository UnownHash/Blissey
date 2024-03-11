#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

if ! "$dragonitelog"
then
  exit
fi

process_time=$(date -d '5 minute ago' +%Y"-"%m"-"%d" "%H":"%M":00")
m1=$(date -d '5 minute ago' +%H":"%M":")
m2=$(date -d '4 minute ago' +%H":"%M":")
m3=$(date -d '3 minute ago' +%H":"%M":")
m4=$(date -d '2 minute ago' +%H":"%M":")
m5=$(date -d '1 minute ago' +%H":"%M":")
dlog=$dragonite_path/logs/dragonite.log
plog=$folder/tmp/d2_interval.log

# Logging prep
start=$(date '+%Y%m%d %H:%M:%S')

if [[ $(ls -l $dlog | wc -l) != 0  ]] ;then

# get loglines
  mkdir -p $folder/tmp
  if [[ $(date -d '5 minute ago' +%M) == "55" ]] ;then
    logtime=$(date +%Y"-"%m"-"%d"T"%H)
    dlog="${dragonite_path}/logs/dragonite-${logtime}*"
    sleep 30s
    zcat $dlog | awk '$3 ~ /'$m1'/ || $3 ~ /'$m2'/ || $3 ~ /'$m3'/ || $3 ~ /'$m4'/ || $3 ~ /'$m5'/' > $plog
#    zgrep "${m1}\|${m2}\|${m3}\|${m4}\|${m5}" $dlog > $plog
  else
    cat $dlog | awk '$3 ~ /'$m1'/ || $3 ~ /'$m2'/ || $3 ~ /'$m3'/ || $3 ~ /'$m4'/ || $3 ~ /'$m5'/' > $plog
#    grep "${m1}\|${m2}\|${m3}\|${m4}\|${m5}" $dlog > $plog
  fi

# set empty vars
  if [[ -z $invasion_worker_name ]] ;then invasion_worker_name="dkmurisanidiot" ;fi
  if [[ -z $fort_area_name ]] ;then fort_area_name="dkmurisanidiot" ;fi

# allow for fort area workers array
  if [[ $fort_area_name != "dkmurisanidiot" ]] ;then
    counter=0
    for i in ${fort_area_name[@]} ;do
      counter=$(( counter + 1 ))
      if (( $counter == 1 )) ;then new="\\[${i}_" ;else new="${new}\\|\\[${i}_" ;fi
   done
  fort_area_name=$new
  fi

# get area/default data
  rpc4=$(zgrep 'RPC Status 4 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc5=$(zgrep 'RPC Status 5 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc6=$(zgrep 'RPC Status 6 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc7=$(zgrep 'RPC Status 7 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc8=$(zgrep 'RPC Status 8 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc9=$(zgrep 'RPC Status 9 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc11=$(zgrep 'RPC Status 11 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc12=$(zgrep 'RPC Status 12 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc13=$(zgrep 'RPC Status 13 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc14=$(zgrep 'RPC Status 14 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc15=$(zgrep 'RPC Status 15 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc16=$(zgrep 'RPC Status 16 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc17=$(zgrep 'RPC Status 17 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  rpc18=$(zgrep 'RPC Status 18 received' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  mitm500=$(zgrep -c 'ERROR_UNKNOWN' $plog)
  mitm501=$(zgrep -c 'ERROR_RETRY_LATER' $plog)
  mitm502=$(zgrep -c 'ERROR_WORKER_STOPPED' $plog)
  mitm503=$(zgrep -c 'ERROR_RECONNECT' $plog)
  mitmLoginErr=$(zgrep -c 'Login for user.*error' $plog)
  proxyBan=$(zgrep -c 'PTC Ban Detected on proxy' $plog)
  wsError=$(zgrep -c 'WS Error' $plog)
  wsClose=$(zgrep -c 'WS Has been closed' $plog)
  wsMitmRecon=$(zgrep -c 'received from Mitm.*triggering reconnect' $plog)
  authReq=$(zgrep -c 'Requested auth' $plog)
  authed=$(zgrep -c 'Authenticated user' $plog)
  login=$(zgrep -c 'Login for user.*to device.*successful' $plog)
  swTotal=$(zgrep 'Final request counts' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swWarnSusp=$(zgrep 'Account .* marked as suspended' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swBanned=$(zgrep 'Account .* marked as banned' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swDisabled=$(zgrep 'Account .* marked as disabled' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swDayLimit=$(zgrep 'Exceeded daily limit. New account needed' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swRange=$(zgrep 'Got out of range 10 times. Possibly exceeded daily limit. New account needed' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swTime=$(zgrep 'Maximum connection time exceeded' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swStop=$(zgrep 'Pokestop is in cooldown, new account needed' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swLLapi=$(zgrep 'Low level api reports recycle required' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  swQdist=$(zgrep 'Long distance jump in questing' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  backoff=$(zgrep 'BACKOFF: Error logging into Pogo\|BACKOFF: New account attempt' $plog | grep -v "\[${invasion_worker_name}_" | grep -v "${fort_area_name}" |wc -l)
  noAccount=$(zgrep -c 'No accounts available to authenticate' $plog)
  released24h=$(zgrep -c 'which is less than 24 hours ago. This is probably not what you want' $plog)
  released7d=$(zgrep -c 'which is less than 1 week ago. This is probably not what you want' $plog)
  minAuthT=$(zgrep 'Authenticated user' $plog | awk '{print $10}' | sed 's/)//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s min)
  maxAuthT=$(zgrep 'Authenticated user' $plog | awk '{print $10}' | sed 's/)//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s max)
  avgAuthT=$(zgrep 'Authenticated user' $plog | awk '{print $10}' | sed 's/)//g' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s 'if length == 0 then 0 else add/length end')
  monchange=$(zgrep -c 'Encounter.*pokemon changed' $plog)

# insert area/default data
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into dragoLog (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,mitm500,mitm501,mitm502,mitm503,mitmLoginErr,proxyBan,wsError,wsClose,wsMitmRecon,authReq,authed,login,swTotal,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,backoff,noAccount,released24h,released7d,minAuthT,maxAuthT,avgAuthT,monchange) values ('$process_time',5,'$rpc4','$rpc5','$rpc6','$rpc7','$rpc8','$rpc9','$rpc11','$rpc12','$rpc13','$rpc14','$rpc15','$rpc16','$rpc17','$rpc18','$mitm500','$mitm501','$mitm502','$mitm503','$mitmLoginErr','$proxyBan','$wsError','$wsClose','$wsMitmRecon','$authReq','$authed','$login','$swTotal','$swWarnSusp','$swBanned','$swDisabled','$swDayLimit','$swRange','$swTime','$swStop','$swLLapi','$swQdist','$backoff','$noAccount','$released24h','$released7d','$minAuthT','$maxAuthT','$avgAuthT','$monchange');"

# get fort data
  if [[ $fort_area_name != "dkmurisanidiot" ]] ;then
    rpc4=$(zgrep 'RPC Status 4 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc5=$(zgrep 'RPC Status 5 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc6=$(zgrep 'RPC Status 6 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc7=$(zgrep 'RPC Status 7 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc8=$(zgrep 'RPC Status 8 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc9=$(zgrep 'RPC Status 9 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc11=$(zgrep 'RPC Status 11 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc12=$(zgrep 'RPC Status 12 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc13=$(zgrep 'RPC Status 13 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc14=$(zgrep 'RPC Status 14 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc15=$(zgrep 'RPC Status 15 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc16=$(zgrep 'RPC Status 16 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc17=$(zgrep 'RPC Status 17 received' $plog | grep "${fort_area_name}" | wc -l)
    rpc18=$(zgrep 'RPC Status 18 received' $plog | grep "${fort_area_name}" | wc -l)
    swTotal=$(zgrep 'Final request counts' $plog | grep "${fort_area_name}" |wc -l)
    swWarnSusp=$(zgrep 'Account .* marked as suspended' $plog | grep "${fort_area_name}" | wc -l)
    swBanned=$(zgrep 'Account .* marked as banned' $plog | grep "${fort_area_name}" | wc -l)
    swDisabled=$(zgrep 'Account .* marked as disabled' $plog | grep "${fort_area_name}" | wc -l)
    swDayLimit=$(zgrep 'Exceeded daily limit. New account needed' $plog | grep "${fort_area_name}" | wc -l)
    swRange=$(zgrep 'Got out of range 10 times. Possibly exceeded daily limit. New account needed' $plog | grep "${fort_area_name}" | wc -l)
    swTime=$(zgrep 'Maximum connection time exceeded' $plog | grep "${fort_area_name}" | wc -l)
    swStop=$(zgrep 'Pokestop is in cooldown, new account needed' $plog | grep "${fort_area_name}" |wc -l)
    swLLapi=$(zgrep 'Low level api reports recycle required' $plog | grep "${fort_area_name}"  |wc -l)
    backoff=$(zgrep 'BACKOFF: Error logging into Pogo\|BACKOFF: New account attempt' $plog | grep "${fort_area_name}" | wc -l)

# insert fort data
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into dragoLog_fort (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,swTotal,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,backoff) values ('$process_time',5,'$rpc4','$rpc5','$rpc6','$rpc7','$rpc8','$rpc9','$rpc11','$rpc12','$rpc13','$rpc14','$rpc15','$rpc16','$rpc17','$rpc18','$swTotal','$swWarnSusp','$swBanned','$swDisabled','$swDayLimit','$swRange','$swTime','swStop','$swLLapi','$backoff');"
  fi
# get invasion data
  if [[ $invasion_worker_name != "dkmurisanidiot" ]] ;then
    rpc4=$(zgrep 'RPC Status 4 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc5=$(zgrep 'RPC Status 5 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc6=$(zgrep 'RPC Status 6 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc7=$(zgrep 'RPC Status 7 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc8=$(zgrep 'RPC Status 8 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc9=$(zgrep 'RPC Status 9 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc11=$(zgrep 'RPC Status 11 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc12=$(zgrep 'RPC Status 12 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc13=$(zgrep 'RPC Status 13 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc14=$(zgrep 'RPC Status 14 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc15=$(zgrep 'RPC Status 15 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc16=$(zgrep 'RPC Status 16 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc17=$(zgrep 'RPC Status 17 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    rpc18=$(zgrep 'RPC Status 18 received' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    swTotal=$(zgrep 'Final request counts' $plog | grep "\[${invasion_worker_name}_" |wc -l)
    swWarnSusp=$(zgrep 'Account .* marked as suspended' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    swBanned=$(zgrep 'Account .* marked as banned' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    swDisabled=$(zgrep 'Account .* marked as disabled' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    swDayLimit=$(zgrep 'Exceeded daily limit. New account needed' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    swRange=$(zgrep 'Got out of range 10 times. Possibly exceeded daily limit. New account needed' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    swTime=$(zgrep 'Maximum connection time exceeded' $plog | grep "\[${invasion_worker_name}_" | wc -l)
    swStop=$(zgrep 'Pokestop is in cooldown, new account needed' $plog | grep "\[${invasion_worker_name}_" |wc -l)
    swLLapi=$(zgrep 'Low level api reports recycle required' $plog | grep "\[${invasion_worker_name}_" |wc -l)
    swQdist=$(zgrep 'Long distance jump in questing' $plog | grep "\[${invasion_worker_name}_" |wc -l)
    backoff=$(zgrep 'BACKOFF: Error logging into Pogo\|BACKOFF: New account attempt' $plog | grep "\[${invasion_worker_name}_" | wc -l)

# insert invasion data
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into dragoLog_invasion (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,swTotal,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,backoff) values ('$process_time',5,'$rpc4','$rpc5','$rpc6','$rpc7','$rpc8','$rpc9','$rpc11','$rpc12','$rpc13','$rpc14','$rpc15','$rpc16','$rpc17','$rpc18','$swTotal','$swWarnSusp','$swBanned','$swDisabled','$swDayLimit','$swRange','$swTime','$swStop','$swLLapi','$swQdist','$backoff');"
  fi

else
  echo "No dragonite logfile found to process ($plog)" >> $folder/logs/log_$(date '+%Y%m').log
fi

echo ""
# add logline
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$start" +%s)))%60)))
echo "[$start] [$stop] [$diff] rpl5 drago log processing" >> $folder/logs/log_$(date '+%Y%m').log
echo "All done!"

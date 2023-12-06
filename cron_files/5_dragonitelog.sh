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
  rpc4=$(zgrep 'RPC Status 4 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc5=$(zgrep 'RPC Status 5 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc6=$(zgrep 'RPC Status 6 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc7=$(zgrep 'RPC Status 7 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc8=$(zgrep 'RPC Status 8 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc9=$(zgrep 'RPC Status 9 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc11=$(zgrep 'RPC Status 11 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc12=$(zgrep 'RPC Status 12 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc13=$(zgrep 'RPC Status 13 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc14=$(zgrep 'RPC Status 14 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc15=$(zgrep 'RPC Status 15 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc16=$(zgrep 'RPC Status 16 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc17=$(zgrep 'RPC Status 17 received' $plog | grep -v "${fort_area_name}" |wc -l)
  rpc18=$(zgrep 'RPC Status 18 received' $plog | grep -v "${fort_area_name}" |wc -l)
  mitmUnknown=$(zgrep -c 'ERROR_UNKNOWN' $plog)
  mitmNoGame=$(zgrep -c 'ERROR_GAME_NOT_READY' $plog)
  mitmLogginIn=$(zgrep -c 'ERROR_LOGIN_IN_PROGRESS' $plog)
  mitmTokenRej=$(zgrep -c 'ERROR_TOKEN_REJECTED' $plog)
  mitmNotLogged=$(zgrep -c 'ERROR_NOT_LOGGED_IN' $plog)
  mitmLoginErr=$(zgrep -c 'Login for user error' $plog)
  proxyBan=$(zgrep -c 'PTC Ban Detected on proxy' $plog)
  wsError=$(zgrep -c 'WS Error' $plog)
  wsClose=$(zgrep -c 'WS Has been closed' $plog)
  wsMitmRecon=$(zgrep -c 'received from Mitm.*triggering reconnect' $plog)
  authReq=$(zgrep -c 'Requested auth' $plog)
  authed=$(zgrep -c 'Authenticated user' $plog)
  login=$(zgrep -c 'Login for user.*to device.*successful' $plog)
  swWarnSusp=$(zgrep 'Account .* marked as suspended' $plog | grep -v "${fort_area_name}" |wc -l)
  swBanned=$(zgrep 'Account .* marked as banned' $plog | grep -v "${fort_area_name}" |wc -l)
  swDisabled=$(zgrep 'Account .* marked as disabled' $plog | grep -v "${fort_area_name}" |wc -l)
  swDayLimit=$(zgrep 'Exceeded daily limit. New account needed' $plog | grep -v "${fort_area_name}" |wc -l)
  swRange=$(zgrep 'Got out of range 10 times. Possibly exceeded daily limit. New account needed' $plog | grep -v "${fort_area_name}" |wc -l)
  swTime=$(zgrep 'Maximum connection time exceeded' $plog | grep -v "${fort_area_name}" |wc -l)
  backoff=$(zgrep 'BACKOFF: Error logging into Pogo' $plog | grep -v "${fort_area_name}" |wc -l)
  released24h=$(zgrep -c 'which is less than 24 hours ago. This is probably not what you want' $plog)
  released7d=$(zgrep -c 'which is less than 1 week ago. This is probably not what you want' $plog)

# insert area/default data
  MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into dragoLog (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,mitmUnknown,mitmNoGame,mitmLogginIn,mitmTokenRej,mitmNotLogged,mitmLoginErr,proxyBan,wsError,wsClose,wsMitmRecon,authReq,authed,login,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,backoff,released24h,released7d) values ('$process_time',5,'$rpc4','$rpc5','$rpc6','$rpc7','$rpc8','$rpc9','$rpc11','$rpc12','$rpc13','$rpc14','$rpc15','$rpc16','$rpc17','$rpc18','$mitmUnknown','$mitmNoGame','$mitmLogginIn','$mitmTokenRej','$mitmNotLogged','$mitmLoginErr','$proxyBan','$wsError','$wsClose','$wsMitmRecon','$authReq','$authed','$login','$swWarnSusp','$swBanned','$swDisabled','$swDayLimit','$swRange','$swTime','$backoff','$released24h','$released7d');"

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
    swWarnSusp=$(zgrep 'Account .* marked as suspended' $plog | grep "${fort_area_name}" | wc -l)
    swBanned=$(zgrep 'Account .* marked as banned' $plog | grep "${fort_area_name}" | wc -l)
    swDisabled=$(zgrep 'Account .* marked as disabled' $plog | grep "${fort_area_name}" | wc -l)
    swDayLimit=$(zgrep 'Exceeded daily limit. New account needed' $plog | grep "${fort_area_name}" | wc -l)
    swRange=$(zgrep 'Got out of range 10 times. Possibly exceeded daily limit. New account needed' $plog | grep "${fort_area_name}" | wc -l)
    swTime=$(zgrep 'Maximum connection time exceeded' $plog | grep "${fort_area_name}" | wc -l)
    backoff=$(zgrep 'BACKOFF: Error logging into Pogo' $plog | grep "${fort_area_name}" | wc -l)

# insert fort data
    MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into dragoLog_fort (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,backoff) values ('$process_time',5,'$rpc4','$rpc5','$rpc6','$rpc7','$rpc8','$rpc9','$rpc11','$rpc12','$rpc13','$rpc14','$rpc15','$rpc16','$rpc17','$rpc18','$swWarnSusp','$swBanned','$swDisabled','$swDayLimit','$swRange','$swTime','$backoff');"
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

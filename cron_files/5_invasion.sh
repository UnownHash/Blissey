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
# get data
workers=$(zgrep "\[${invasion_worker_name}_" $plog | awk '{print $4}' | sort | uniq | wc -l)
if [[ workers == 0 ]] ;then
  avgTime=0
  detect=0
  failed=0
  done=0
  expired=0
  qmin=0
  qmax=0
  qavg=0
else
  avgTime=$(zgrep "\[${invasion_worker_name}_" $plog | grep 'Done with invasion' | grep -oP '(?<=Took: ).*(?= \| Time left)' | sed 's/\(m[0-9]\)/m\1/g' | awk -F"mm" '{ if (substr($NF,length($NF)-1) == "ms") {print substr($NF,1,length($NF)-2)} else if (substr($NF,length($NF)-1) == "µs") {print substr($NF,1,length($NF)-2) /1000} else if ($1 != $NF) {print $1*60000 + $NF*1000} else {print substr($NF,1,length($NF)-1) *1000} }' | jq -s 'if length == 0 then 0 else add/length end')
  detect=$(zgrep -c 'Detecting lineup for Invasion' $plog)
  failed=$(zgrep -c 'failed to detect lineup for invasion' $plog)
  done=$(zgrep -c 'Done with invasion' $plog)
  expired=$(zgrep -c 'Invasion .* expired' $plog)
  qmin=$(zgrep 'invasions in queue' $plog | awk '{print $6}' | jq -s min)
  qmax=$(zgrep 'invasions in queue' $plog | awk '{print $6}' | jq -s max)
  qavg=$(zgrep 'invasions in queue' $plog | awk '{print $6}' | jq -s 'if length == 0 then 0 else add/length end')
fi

gmin=$(zgrep 'Done with invasion .* of type `grunt`' $plog | grep -oP '(?<=Time left before despawn: ).*(?=)' | sed 's/\(m[0-9]\)/m\1/g' | sed 's/h/mm/g' | awk -F"mm" '{ if (NF==3) {print $1*60 + $2} else if (NF==2) {print $1} else {print 0} }' | jq -s min)
if [[ $gmin == "null" ]] ;then
  gmin=0
  gmax=0
  gavg=0
else
  gmax=$(zgrep 'Done with invasion .* of type `grunt`' $plog | grep -oP '(?<=Time left before despawn: ).*(?=)' | sed 's/\(m[0-9]\)/m\1/g' | sed 's/h/mm/g' | awk -F"mm" '{ if (NF==3) {print $1*60 + $2} else if (NF==2) {print $1} else {print 0} }' | jq -s max)
  gavg=$(zgrep 'Done with invasion .* of type `grunt`' $plog | grep -oP '(?<=Time left before despawn: ).*(?=)' | sed 's/\(m[0-9]\)/m\1/g' | sed 's/h/mm/g' | awk -F"mm" '{ if (NF==3) {print $1*60 + $2} else if (NF==2) {print $1} else {print 0} }' | jq -s 'if length == 0 then 0 else add/length end')
fi

lmin=$(zgrep 'Done with invasion .* of type `leader`' $plog | grep -oP '(?<=Time left before despawn: ).*(?=)' | sed 's/\(m[0-9]\)/m\1/g' | sed 's/h/mm/g' | awk -F"mm" '{ if (NF==3) {print $1*60 + $2} else if (NF==2) {print $1} else {print 0} }' | jq -s min)
if [[ $lmin == "null" ]] ;then
  lmin=0
  lmax=0
  lavg=0
else
  lmax=$(zgrep 'Done with invasion .* of type `leader`' $plog | grep -oP '(?<=Time left before despawn: ).*(?=)' | sed 's/\(m[0-9]\)/m\1/g' | sed 's/h/mm/g' | awk -F"mm" '{ if (NF==3) {print $1*60 + $2} else if (NF==2) {print $1} else {print 0} }' | jq -s max)
  lavg=$(zgrep 'Done with invasion .* of type `leader`' $plog | grep -oP '(?<=Time left before despawn: ).*(?=)' | sed 's/\(m[0-9]\)/m\1/g' | sed 's/h/mm/g' | awk -F"mm" '{ if (NF==3) {print $1*60 + $2} else if (NF==2) {print $1} else {print 0} }' | jq -s 'if length == 0 then 0 else add/length end')
fi
#echo $workers $avgTime $detect $done $expired $qmin $qmax $qavg $gmin $gmax $gavg $lmin $lmax $lavg

if [[ workers != 0 ]] ;then
  for worker in $(zgrep "\[${invasion_worker_name}_" $plog | awk '{print $4}' | sort | uniq | sed 's/\[/\\\[/g' | sed 's/\]/\\\]/g') ;do
    start=$(zgrep $worker $plog | grep 'Done with invasion' | head -1)
    stop=$(zgrep $worker $plog | grep 'Done with invasion' | tail -1)
    if [[ ! -z $start ]] ;then
      wglb=$(echo $start | grep -oP '(?<=Grunts line-ups: )[0-9]+')
      wgle=$(echo $stop | grep -oP '(?<=Grunts line-ups: )[0-9]+')
      if (( $wglb <= $wgle )) ;then gl=$(( $gl+$wgle-$wglb )) ;else gl=$(( $gl+$wgle )) ;fi

      wllb=$(echo $start | grep -oP '(?<=Leaders line-ups: )[0-9]+')
      wlle=$(echo $stop | grep -oP '(?<=Leaders line-ups: )[0-9]+')
      if (( $wllb <= $wlle )) ;then ll=$(( $ll+$wlle-$wllb )) ;else ll=$(( $ll+$wlle )) ;fi

      wgcb=$(echo $start | grep -oP '(?<=Giovanni confirmed: )[0-9]+')
      wgce=$(echo $stop | grep -oP '(?<=Giovanni confirmed: )[0-9]+')
      if (( $wgcb <= $wgce )) ;then gc=$(( $gc+$wgce-$wgcb )) ;else gc=$(( $gc+$wgce )) ;fi

      wgilb=$(echo $start | grep -oP '(?<=Giovanni line-ups: )[0-9]+')
      wgile=$(echo $stop | grep -oP '(?<=Giovanni line-ups: )[0-9]+')
      if (( $wgilb <= $wgile )) ;then gil=$(( $gil+$wgile-$wgilb )) ;else gil=$(( $gil+$wgile )) ;fi
    else
      echo "[$startt] Invasion worker $worker didn't do anything usefull!!" >> $folder/logs/log_$(date '+%Y%m').log
    fi
  done
#echo $gl $ll $gc $gil
fi


# insert data
MYSQL_PWD=$sqlpass mysql -u$sqluser -h$dbip -P$dbport $blisseydb -e "insert ignore into stats_invasion (datetime,rpl,workers,avgTime,detect,failed,done,expired,qmin,qmax,qavg,grLine,leLine,giConf,giLine,gmin,gmax,gavg,lmin,lmax,lavg) values ('$process_time',5,'$workers','$avgTime','$detect','$failed','$done','$expired','$qmin','$qmax','$qavg','$gl','$ll','$gc','$gil','$gmin','$gmax','$gavg','$lmin','$lmax','$lavg');"

else
  echo "[$startt] No interval log found to process ($plog)" >> $folder/logs/log_$(date '+%Y%m').log
fi

## cleanup, remove interval log
rm -f $plog

echo ""
# add logline
stop=$(date '+%Y%m%d %H:%M:%S')
diff=$(printf '%02dm:%02ds\n' $(($(($(date -d "$stop" +%s) - $(date -d "$startt" +%s)))/60)) $(($(($(date -d "$stop" +%s) - $(date -d "$startt" +%s)))%60)))
echo "[$startt] [$stop] [$diff] rpl5 invasion processing" >> $folder/logs/log_$(date '+%Y%m').log
echo "All done!"

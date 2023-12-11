-- settings
select @period := concat(date(now() - interval 60 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl  := 60;

-- aggregation fort worker
INSERT IGNORE INTO stats_worker_fort (datetime,rpl,worker,fetchRaid,modeLocations,fortLookup,totalProtoTimeFort,totalProtoTimeRaid)
SELECT
@period,
@rpl,
worker,
sum(fetchRaid),
sum(modeLocations),
sum(fortLookup),
sum(totalProtoTimeFort),
sum(totalProtoTimeRaid)

FROM stats_worker_fort
WHERE
datetime >= @period and
datetime < @stop and
rpl = 15
GROUP BY @period,@rpl,worker
;

-- aggregation fort prio raid
INSERT IGNORE INTO stats_prioraid (datetime,rpl,scanCount,scanMin,scanMax,scanAvg,raidMin,raidMax,raidAvg,raidActiveMin,raidActiveMax,raidActiveAvg,raidQueueMin,raidQueueMax,raidQueueAvg,Qcount)
SELECT
@period,
@rpl,
sum(scanCount),
min(scanMin),
max(scanMax),
sum(scanAvg*scanCount)/sum(scanCount),
min(raidMin),
max(raidMax),
sum(raidAvg*scanCount)/sum(scanCount),
min(raidActiveMin),
max(raidActiveMax),
sum(raidActiveAvg*Qcount)/sum(Qcount),
min(raidQueueMin),
max(raidQueueMax),
sum(raidQueueAvg*Qcount)/sum(Qcount),
sum(Qcount)

FROM stats_prioraid   
WHERE
datetime >= @period and
datetime < @stop and
rpl = 15
GROUP BY @period,@rpl       
;

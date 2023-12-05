-- settings
select @period := concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl  := 1440;

-- process data
insert ignore into stats_worker (datetime,rpl,controller_worker,mode,device_worker,numRep,loc_time,loc_count,loc_success,mons_seen,mons_enc,distance,
	retries,timeElapsed,locationDelay,gmos,gmoInitialSuccess,gmo0fail,gmo1fail,gmo2fail,gmo3fail,gmo4fail,gmo5fail,gmo6fail,gmo7fail,gmo8fail,gmoNoCell,gmoGivingUp,gmoDelay)
select
@period,
@rpl,
controller_worker,
case when min(mode) = 'FortMode' then 'FortMode' else 'PokemonMode' end,
'',
count(controller_worker),
sum(loc_time),
sum(loc_count),
sum(loc_success),
sum(mons_seen),
sum(mons_enc),
sum(distance),
sum(retries),
sum(timeElapsed),
sum(locationDelay),
sum(gmos),
sum(gmoInitialSuccess),
sum(gmo0fail),
sum(gmo1fail),
sum(gmo2fail),
sum(gmo3fail),
sum(gmo4fail),
sum(gmo5fail),
sum(gmo6fail),
sum(gmo7fail),
sum(gmo8fail),
sum(gmoNoCell),
sum(gmoGivingUp),
sum(gmoDelay)

from stats_worker

where
datetime >= @period and
datetime < @stop and
rpl = 60

group by controller_worker
;

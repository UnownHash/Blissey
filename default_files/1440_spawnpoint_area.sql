-- Settings
select @period := concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl := '1440';

-- Process data
insert ignore into stats_spawnpoint (datetime,rpl,area,fence,spawnpoints,verified,seen,1d,3d,5d,7d,14d)
select
from_unixtime(@period) as 'period',
@rpl,
area,
fence,
max(spawnpoints),
max(verified),
max(seen),
min(1d),
min(3d),
min(5d),
min(7d),
min(14d)

from stats_spawnpoint 
where
datetime >= @period and
datetime < @stop and
rpl = 60

group by area,fence
;

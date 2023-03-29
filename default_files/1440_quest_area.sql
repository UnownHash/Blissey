-- settings
select @period := concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl  := 1440;

-- process data
insert ignore into stats_quest_area (datetime,rpl,area,fence,stops,AR,nonAR,ARcum,nonARcum)
select
@period,
@rpl,
area,
fence,
max(stops),
sum(AR),
sum(nonAR),
max(ARcum),
max(nonARcum)

from stats_quest_area

where
datetime >= @period and
datetime < @stop and
rpl = 60

group by area,fence
;

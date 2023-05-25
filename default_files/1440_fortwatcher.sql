-- settings
select @period := concat(date(now() - interval 1440 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 1440 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl  := 1440;

-- process data
insert ignore into stats_forts (datetime,rpl,area,fence,webhook_received,webhook_send,webhook_skip,webhook_nohook,stop_remove,gym_remove,fort_conversion,portal_add,stop_add,gym_add,name_edit,location_edit,image_edit,description_edit)
select
@period,
@rpl,
area,
fence,
sum(webhook_received),
sum(webhook_send),
sum(webhook_skip),
sum(webhook_nohook),
sum(stop_remove),
sum(gym_remove),
sum(fort_conversion),
sum(portal_add),
sum(stop_add),
sum(gym_add),
sum(name_edit),
sum(location_edit),
sum(image_edit),
sum(description_edit)

from stats_forts

where
datetime >= @period and
datetime < @stop and
rpl = 60

group by area,fence
;

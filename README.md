# Blissey

Process controller/golbat data for worker, pokemon, quest and spawnpoint (for defined areas) into seperate stats tables.<BR>
Processing is done on interval 15/60/1440/10080 minutes and can be displayed by pre-defined grafana templates.
<BR>


## 1 Prerequisites
- tested on: mariadb 10.5/10.6, mysql server 8.0.31
- add `geofence.json` to golbat/geojson for raw area stats
- enable worker stats on 5m interval in controller config

## 2 Setup
- clone Blissey, `git clone https://github.com/UnownHash/Blissey.git && cd Blissey`
- create stats db and user (user needs to have access to stats/controller/golbat db)
- copy and fill out config, `cp default_files/config.ini.example config.ini`
- execute setting.run
- add content of crontab.txt to your cron
- add quest and mon area fences to table geofences and execute settings.run once more to populate column `st`
```
insert ignore into geofences (area,fence,type,coords) values
('Newyork','Newyork_centre','mon','lat1 lon1,lat2 lon2,lat3 lon3,lat1 lon1');

insert ignore into geofences (area,fence,type,coords) values
('Newyork','Newyork_south','mon','lat1 lon1,lat2 lon2,lat3 lon3,lat1 lon1');

insert ignore into geofences (area,type,coords) values
('Newyork','quest','lat1 lon1,lat2 lon2,lat3 lon3,lat1 lon1');

- column fence is only used in case you use subfences for an area(town), will default to area when not included
- first and last coordinate must be the same for column coords
- after changing or adding fences always execute setting.run to populate column st
```
<BR>
Note 1: grafana templates will group before first "_" meaning for instance in the example above when looking at stats for area Newyork without specifying a fence the 2 mon areas will be combined<BR>

## 3 Grafana
- Install Grafana, more details can be found at https://grafana.com/docs/grafana/latest/installation/debian/#install-from-apt-repository or if you prefer to use docker <https://hub.docker.com/r/grafana/grafana>
- Create datasource for stats db
- Add datasource name to config.ini
- After executing settings.run, import the dashboards from Blissey/grafana by selecting ``+`` and then import


## 4 Updates
- depending on changes but to be safe, pull+execute settings.run+update crontab
- replace changed grafana templates
<BR>
<BR>
A logs folder will be created in Blissey, any errors during execution are printed before the actual logline

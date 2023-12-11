# Blissey

Process controller/golbat data for workers, pokemon, quest, account, drago log into seperate stats tables.<BR>
Processing is done on interval 15/60/1440/10080 minutes and can be displayed by pre-defined grafana templates.
<BR>


## 1 Prerequisites
- tested on: mariadb 10.6
- add Golbat/geojson/geofence.json or setup Koji api, containing your mon scan fences. Golbat will use these fences to write raw area mon stats to db.
- enable stats in controller config so it writes raw worker stats
- enable save logs in controller config is you want them processed 

## 2 Setup
- clone Blissey, `git clone https://github.com/UnownHash/Blissey.git && cd Blissey`
- create stats db and user (user needs to have access to stats/controller/golbat db)
- copy and fill out config, `cp default_files/config.ini.example config.ini`
- execute setting.run
- add content of crontab.txt to your cron

### 2.1 Geofences
Blissey needs quest and mon fences in order to aggregate data. 2 ways of doing this:<BR>
1 Use Koji<BR>
- set config.ini accordingly
- grant sql user access to koji db
- project_golbat, this project should contain your mon fences. Ideally this is same project as used for 2nd point in prerequisites to ensure alligment. 
- project_controller, this project should contain your quest fences. Again to assure alligment your controller(Dragonite) project would be a logical choice.
In case all area quest/mon fences are identical both can point to the same Koji project. 
<BR>
2 Manually add them to Blissey table geofences<BR>
add quest and mon area fences to table geofences and execute settings.run once more to populate columns `st` and `st_lonlat`<BR>

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
- Import dashboards from Blissey/default_files/grafana/ by selecting ``+`` and then import


## 4 Updates
- depending on changes but to be safe, pull+execute settings.run+adjust config.ini when needed+update crontab
- replace changed grafana templates
<BR>
<BR>
A logs folder will be created in Blissey, any errors during execution are printed before the actual logline

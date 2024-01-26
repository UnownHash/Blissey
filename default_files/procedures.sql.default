DROP PROCEDURE IF EXISTS blissey.rpl15questarea;
DROP PROCEDURE IF EXISTS blissey.rpl15spawnarea;

DROP PROCEDURE IF EXISTS blissey.rpl5questarea;
DELIMITER //
CREATE PROCEDURE blissey.rpl5questarea()
BEGIN

-- set vars
  SET @period = (select unix_timestamp(concat(date(now() - interval 5 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 5 minute)) DIV 300) * 300))) );
  SET @stop = (select unix_timestamp(concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 300) * 300))) );
  SET @perioddate = (select unix_timestamp(date(from_unixtime(@period))));

-- get areas
SET @row_number = 0;
DROP TEMPORARY TABLE IF EXISTS blissey.areas;
-- nonKoji CREATE TEMPORARY TABLE blissey.areas AS (
-- nonKoji   SELECT (@row_number:=@row_number + 1) as 'id',area,fence,st_lonlat
-- nonKoji   FROM blissey.geofences
-- nonKoji   WHERE st_lonlat is not NULL and (type='quest' or type='both'));
-- useKoji CREATE TEMPORARY TABLE blissey.areas AS (
-- useKoji   SELECT (@row_number:=@row_number + 1) as 'id',a.name as 'area',a.name as 'fence',st_geomfromgeojson(a.geometry) as 'st_lonlat'
-- useKoji   FROM koji.geofence a
-- useKoji     inner join koji.geofence_project c on a.id=c.geofence_id
-- useKoji     inner join koji.project d on c.project_id=d.id
-- useKoji   WHERE d.name='project_controller' and a.name not in (fortarray));

-- process fences
BEGIN
  SET @max = (select max(id) from blissey.areas);
  SET @current = 1;

  WHILE @current <= @max DO
    SET @minX = (select ST_Y(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 1)) from blissey.areas where id=@current);
    SET @maxX = (select ST_Y(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 3)) from blissey.areas where id=@current);
    SET @minY = (select ST_X(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 1)) from blissey.areas where id=@current);
    SET @maxY = (select ST_X(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 2)) from blissey.areas where id=@current);

    INSERT IGNORE INTO blissey.stats_quest_area (datetime,rpl,area,fence,stops,AR,nonAR,ARcum,nonARcum)
    SELECT
    from_unixtime(@period) as 'period',
    5 as 'rpl',
    area,
    fence,
    count(a.id) as 'stops',
    ifnull(sum(case when cast(quest_timestamp AS SIGNED) >= @period and cast(quest_timestamp AS SIGNED) < @stop then 1 end),0) as 'AR',
    ifnull(sum(case when cast(alternative_quest_timestamp AS SIGNED) >= @period and cast(alternative_quest_timestamp AS SIGNED) < @stop then 1 end),0) as 'nonAR',
    ifnull(sum(case when unix_timestamp() < quest_expiry then 1 end),0) as 'ARcum',
    ifnull(sum(case when unix_timestamp() < alternative_quest_expiry then 1 end),0) as 'nonARcum'
    FROM golbat.pokestop a, blissey.areas b
    WHERE b.id = @current and a.lat between @minX and @maxX and a.lon between @minY and @maxY and a.deleted=0 and ST_CONTAINS(b.st_lonlat, point(a.lon,a.lat))
    GROUP BY area,fence;

    SET @current = @current + 1;
  END WHILE;
END;

DROP TEMPORARY TABLE blissey.areas;

END
//
DELIMITER ;

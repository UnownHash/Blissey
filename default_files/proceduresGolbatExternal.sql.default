DROP PROCEDURE IF EXISTS golbat.rpl5questarea;
DELIMITER //
CREATE PROCEDURE golbat.rpl5questarea()
BEGIN

-- set vars
  SET @period = (select unix_timestamp(concat(date(now() - interval 5 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 5 minute)) DIV 300) * 300))) );
  SET @stop = (select unix_timestamp(concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 300) * 300))) );
  SET @perioddate = (select unix_timestamp(date(from_unixtime(@period))));

-- get areas
-- useKoji SET @row_number = 0;
-- useKoji DROP TEMPORARY TABLE IF EXISTS golbat.areas;
-- useKoji CREATE TEMPORARY TABLE golbat.areas AS (
-- useKoji   SELECT (@row_number:=@row_number + 1) as 'id',a.name as 'area',a.name as 'fence',st_geomfromgeojson(a.geometry) as 'st_lonlat'
-- useKoji   FROM koji.geofence a
-- useKoji     inner join koji.geofence_project c on a.id=c.geofence_id
-- useKoji     inner join koji.project d on c.project_id=d.id
-- useKoji   WHERE d.name='project_controller' and a.name not in (fortarray));

-- process fences
BEGIN
  SET @max = (select max(id) from golbat.areas);
  SET @current = 1;

  WHILE @current <= @max DO
-- useKoji    SET @minX = (select ST_Y(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 1)) from golbat.areas where id=@current);
-- useKoji    SET @maxX = (select ST_Y(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 3)) from golbat.areas where id=@current);
-- useKoji    SET @minY = (select ST_X(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 1)) from golbat.areas where id=@current);
-- useKoji    SET @maxY = (select ST_X(ST_PointN(ST_ExteriorRing(st_envelope(st_lonlat)), 2)) from golbat.areas where id=@current);
-- nonKoji    SET @minX = (select ST_Y(ST_PointN(ST_ExteriorRing(st_envelope(st_geomfromtext(coords))), 1)) from golbat.areas where id=@current);
-- nonKoji    SET @maxX = (select ST_Y(ST_PointN(ST_ExteriorRing(st_envelope(st_geomfromtext(coords))), 3)) from golbat.areas where id=@current);
-- nonKoji    SET @minY = (select ST_X(ST_PointN(ST_ExteriorRing(st_envelope(st_geomfromtext(coords))), 1)) from golbat.areas where id=@current);
-- nonKoji    SET @maxY = (select ST_X(ST_PointN(ST_ExteriorRing(st_envelope(st_geomfromtext(coords))), 2)) from golbat.areas where id=@current);


    SELECT
    concat(
    "('",
    from_unixtime(@period),
    "',",
    5,
    ",'",
    area,
    "','",
    fence,
    "',",
    count(a.id),
    ",",
    ifnull(sum(case when cast(quest_timestamp AS SIGNED) >= @period and cast(quest_timestamp AS SIGNED) < @stop then 1 end),0),
    ",",
    ifnull(sum(case when cast(alternative_quest_timestamp AS SIGNED) >= @period and cast(alternative_quest_timestamp AS SIGNED) < @stop then 1 end),0),
    ",",
    ifnull(sum(case when unix_timestamp() < quest_expiry then 1 end),0),
    ",",
    ifnull(sum(case when unix_timestamp() < alternative_quest_expiry then 1 end),0),
    "),"
    )
    FROM golbat.pokestop a, golbat.areas b
-- nonKoji    WHERE b.id = @current and a.lat between @minX and @maxX and a.lon between @minY and @maxY and a.deleted=0 and ST_CONTAINS(st_geomfromtext(b.coords), point(a.lon,a.lat))
-- useKoji    WHERE b.id = @current and a.lat between @minX and @maxX and a.lon between @minY and @maxY and a.deleted=0 and ST_CONTAINS(b.st_lonlat, point(a.lon,a.lat))
    GROUP BY area,fence;

    SET @current = @current + 1;
  END WHILE;
END;

DROP TEMPORARY TABLE golbat.areas;

END
//
DELIMITER ;

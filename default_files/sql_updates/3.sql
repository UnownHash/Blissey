ALTER TABLE geofences
ADD COLUMN IF NOT EXISTS `st_lonlat` polygon AFTER `st`,
ADD COLUMN IF NOT EXISTS `country` varchar(4) DEFAULT NULL AFTER `utcoffset`
;

-- update db version
UPDATE version set version = 3 where version.key = 'blissey';

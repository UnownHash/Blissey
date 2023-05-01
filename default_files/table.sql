CREATE TABLE IF NOT EXISTS `version` (
  `key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` smallint(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `geofences` (
  `area` varchar(40) NOT NULL,
  `fence` varchar(40) DEFAULT `Area`,
  `type` enum('mon', 'quest','both'),
  `coords` text NOT NULL,
  `st` polygon,
  `st_lonlat` polygon,
  `km2` decimal(7,2) DEFAULT 0.00,
  `utcoffset` tinyint(4) DEFAULT NULL,
  `country` varchar(4) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`area`,`fence`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `stats_worker` (
  `datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `controller_worker` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_worker` varchar(255) DEFAULT NULL,
  `numRep` int(11) DEFAULT NULL,
  `loc_time` float DEFAULT NULL,
  `loc_count` int(11) DEFAULT NULL,
  `loc_success` int(11) DEFAULT NULL,
  `mons_seen` int(11) DEFAULT NULL,
  `mons_enc` int(11) DEFAULT NULL,
  PRIMARY KEY (`datetime`,`RPL`,`controller_worker`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `stats_mon_area` (
  `datetime` datetime NOT NULL,
  `rpl` smallint(6) NOT NULL,
  `area` varchar(40) NOT NULL,
  `fence` varchar(40) DEFAULT NULL,
  `totMon` int(11) DEFAULT NULL,
  `ivMon` int(11) DEFAULT NULL,
  `verifiedEnc` int(11) DEFAULT NULL,
  `unverifiedEnc` int(11) DEFAULT NULL,
  `verifiedReEnc` int(11) DEFAULT NULL,
  `encSecLeft` int(11) DEFAULT NULL,
  `encTthMax5` int(11) DEFAULT NULL,
  `encTth5to10` int(11) DEFAULT NULL,
  `encTth10to15` int(11) DEFAULT NULL,
  `encTth15to20` int(11) DEFAULT NULL,
  `encTth20to25` int(11) DEFAULT NULL,
  `encTth25to30` int(11) DEFAULT NULL,
  `encTth30to35` int(11) DEFAULT NULL,
  `encTth35to40` int(11) DEFAULT NULL,
  `encTth40to45` int(11) DEFAULT NULL,
  `encTth45to50` int(11) DEFAULT NULL,
  `encTth50to55` int(11) DEFAULT NULL,
  `encTthMin55` int(11) DEFAULT NULL,
  `resetMon` int(11) DEFAULT NULL,
  `re_encSecLeft` int(11) DEFAULT NULL,
  `numWiEnc` int(11) DEFAULT NULL,
  `secWiEnc` int(11) DEFAULT NULL,
  PRIMARY KEY (`datetime`,`rpl`,`area`,`fence`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `stats_spawnpoint` (
  `datetime` datetime NOT NULL,
  `rpl` smallint(6) NOT NULL,
  `area` varchar(40) NOT NULL,
  `fence` varchar(40) DEFAULT NULL,
  `spawnpoints` int(11) DEFAULT NULL,
  `verified` int(11) DEFAULT NULL,
  `seen` int(11) DEFAULT NULL,
  `1d` int(11) DEFAULT NULL,
  `3d` int(11) DEFAULT NULL,
  `5d` int(11) DEFAULT NULL,
  `7d` int(11) DEFAULT NULL,
  `14d` int(11) DEFAULT NULL,
  PRIMARY KEY (`datetime`,`rpl`,`area`,`fence`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `stats_quest_area` (
  `datetime` datetime NOT NULL,
  `rpl` smallint(6) NOT NULL,
  `area` varchar(40) NOT NULL,
  `fence` varchar(40) DEFAULT NULL,
  `stops` int(11) DEFAULT NULL,
  `AR` int(11) DEFAULT NULL,
  `nonAR` int(11) DEFAULT NULL,
  `ARcum` int(11) DEFAULT NULL,
  `nonARcum` int(11) DEFAULT NULL,
  PRIMARY KEY (`datetime`,`rpl`,`area`,`fence`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE geofences
ADD COLUMN IF NOT EXISTS `st_lonlat` polygon AFTER `st`,
ADD COLUMN IF NOT EXISTS `country` varchar(4) DEFAULT NULL AFTER `utcoffset`
;

-- update db version
INSERT IGNORE INTO version values ('blissey',1);
UPDATE version set version = 3 where version.key = 'blissey';

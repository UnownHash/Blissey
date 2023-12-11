CREATE TABLE `accounts` (
  `datetime` datetime NOT NULL,
  `rpl` smallint(6) NOT NULL,
  `dbaccounts` int(11) DEFAULT NULL,
  `warn` int(11) DEFAULT NULL,
  `suspended` int(11) DEFAULT NULL,
  `banned` int(11) DEFAULT NULL,
  `inUse` int(11) DEFAULT NULL,
  `usedIdle` int(11) DEFAULT NULL,
  `unusedIdle` int(11) DEFAULT NULL,
  `consecDis1` int(11) DEFAULT 0,
  `consecDis2` int(11) DEFAULT 0,
  `consecDis3` int(11) DEFAULT 0,
  `consecDis4p` int(11) DEFAULT 0,
  PRIMARY KEY (`datetime`,`rpl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- update db version
UPDATE version set version = 7 where version.key = 'blissey';

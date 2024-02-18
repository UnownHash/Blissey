ALTER TABLE  `dragoLog`
  add column `swTotal` int default NULL AFTER `login`,
  add column `swStop` int default NULL AFTER `swTime`,
  add column `swLLapi` int default NULL AFTER `swStop`,
  add column `swQdist` int default NULL AFTER `swLLapi`;

ALTER TABLE  `dragoLog_fort`
  add column `swTotal` int default NULL AFTER `gmo8`,
  add column `swStop` int default NULL AFTER `swTime`,
  add column `swLLapi` int default NULL AFTER `swStop`,
  add column `swQdist` int default NULL AFTER `swLLapi`;

ALTER TABLE  `dragoLog_invasion`
  add column `swTotal` int default NULL AFTER `gmo8`,
  add column `swStop` int default NULL AFTER `swTime`,
  add column `swLLapi` int default NULL AFTER `swStop`,
  add column `swQdist` int default NULL AFTER `swLLapi`;

-- update db version
UPDATE version set version = 10 where version.key = 'blissey';

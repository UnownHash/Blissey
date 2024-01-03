ALTER TABLE  `dragoLog`
  add column `noAccount` int default NULL after `backoff`,
  add column `minAuthT` int default NULL,
  add column `maxAuthT` int default NULL,
  add column `avgAuthT` int default NULL;

-- update db version
UPDATE version set version = 8 where version.key = 'blissey';

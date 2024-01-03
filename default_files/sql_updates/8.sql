ALTER TABLE  `dragoLog`
  add column `noAccount` int default NULL after `backoff`;

-- update db version
UPDATE version set version = 8 where version.key = 'blissey';

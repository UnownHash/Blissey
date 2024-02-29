ALTER TABLE  `dragoLog`
  rename column `mitmUnknown` to `mitm500`,
  rename column `mitmNoGame` to `mitm501`,
  rename column `mitmLogginIn` to `mitm502`,
  rename column `mitmTokenRej` to `mitm503`,
  drop column `mitmNotLogged`,
  add column `monchange` int default NULL;

-- update db version
UPDATE version set version = 11 where version.key = 'blissey';

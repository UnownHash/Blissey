alter table accounts
  add column `authbanned` int(11) DEFAULT NULL,
  add column `invalid` int(11) DEFAULT NULL
;

alter table dragoLog
  drop column `noGMO`,
  drop column `gmoPoke`,
  drop column `gmo0`,
  drop column `gmo1`,
  drop column `gmo2`,
  drop column `gmo3`,
  drop column `gmo4`,
  drop column `gmo5`,
  drop column `gmo6`,
  drop column `gmo7`,
  drop column `gmo8`,
  drop column `workers`,
  drop column `locations`,
  drop column `totalProtoTime`,
  add column `swSbanned` int(11) DEFAULT NULL,
  add column `swConsecRPC` int(11) DEFAULT NULL,
  add column `totRemoteAuth` int(11) DEFAULT NULL,
  add column `failRemoteAuth` int(11) DEFAULT NULL,
  add column `faultyRemoteAuth` int(11) DEFAULT NULL,
  add column `minRemoteAuthT` int(11) DEFAULT NULL,
  add column `maxRemoteAuthT` int(11) DEFAULT NULL,
  add column `avgRemoteAuthT` int(11) DEFAULT NULL,
  add column `lowDuration` int(11) DEFAULT NULL,
  add column `bgRefreshSuc` int(11) DEFAULT NULL,
  add column `bgRefreshFail` int(11) DEFAULT NULL,
  add column `minBGrefresh` int(11) DEFAULT NULL,
  add column `maxBGrefresh` int(11) DEFAULT NULL,
  add column `avgBGrefresh` int(11) DEFAULT NULL,
  add column `bTokenReq` int(11) DEFAULT NULL,
  add column `bTokenSuc` int(11) DEFAULT NULL,
  add column `bTokenMin` int(11) DEFAULT NULL,
  add column `bTokenMax` int(11) DEFAULT NULL,
  add column `bTokenAvg` int(11) DEFAULT NULL,
  add column `tokenCleared` int(11) DEFAULT NULL
;

alter table dragoLog_fort
  drop column `noGMO`,
  drop column `gmoPoke`,
  drop column `gmo0`,
  drop column `gmo1`,
  drop column `gmo2`,
  drop column `gmo3`,
  drop column `gmo4`,
  drop column `gmo5`,
  drop column `gmo6`,
  drop column `gmo7`,
  drop column `gmo8`,
  add column `swSbanned` int(11) DEFAULT NULL,
  add column `swConsecRPC` int(11) DEFAULT NULL,
  add column `lowDuration` int(11) DEFAULT NULL
;

alter table dragoLog_invasion
  drop column `noGMO`,
  drop column `gmoPoke`,
  drop column `gmo0`,
  drop column `gmo1`,
  drop column `gmo2`,
  drop column `gmo3`,
  drop column `gmo4`,
  drop column `gmo5`,
  drop column `gmo6`,
  drop column `gmo7`,
  drop column `gmo8`,
  add column `swSbanned` int(11) DEFAULT NULL,
  add column `swConsecRPC` int(11) DEFAULT NULL,
  add column `lowDuration` int(11) DEFAULT NULL
;

-- update db version
UPDATE version set version = 90 where version.key = 'blissey';

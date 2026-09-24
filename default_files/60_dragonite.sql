-- settings
select @period := concat(date(now() - interval 60 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl  := 60;

-- aggregation area/generic
INSERT IGNORE INTO dragoLog (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,mitm500,mitm501,mitm502,mitm503,mitmLoginErr,proxyBan,wsError,wsClose,wsMitmRecon,authReq,authed,login,swTotal,swWarnSusp,swBanned,swSbanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,swConsecRPC,backoff,noAccount,released24h,released7d,minAuthT,maxAuthT,avgAuthT,monchange,totRemoteAuth,failRemoteAuth,faultyRemoteAuth,minRemoteAuthT,maxRemoteAuthT,avgRemoteAuthT,lowDuration,bgRefreshSuc,bgRefreshFail,bTokenReq,bTokenSuc,bTokenMin,bTokenMax,bTokenAvg,tokenCleared)
SELECT
@period,
@rpl,
sum(rpc4),
sum(rpc5),
sum(rpc6),
sum(rpc7),
sum(rpc8),
sum(rpc9),
sum(rpc11),
sum(rpc12),
sum(rpc13),
sum(rpc14),
sum(rpc15),
sum(rpc16),
sum(rpc17),
sum(rpc18),
sum(mitm500),
sum(mitm501),
sum(mitm502),
sum(mitm503),
sum(mitmLoginErr),
sum(proxyBan),
sum(wsError),
sum(wsClose),
sum(wsMitmRecon),
sum(authReq),
sum(authed),
sum(login),
sum(swTotal),
sum(swWarnSusp),
sum(swBanned),sum(swSbanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(swStop),
sum(swLLapi),
sum(swQdist),sum(swConsecRPC),
sum(backoff),
sum(noAccount),
sum(released24h),
sum(released7d),
min(minAuthT),
max(maxAuthT),
sum(avgAuthT*authed)/sum(authed),
sum(monchange),
sum(totRemoteAuth),
sum(failRemoteAuth),
sum(faultyRemoteAuth),
min(minRemoteAuthT),
max(maxRemoteAuthT),
sum(avgRemoteAuthT*totRemoteAuth)/sum(totRemoteAuth),
sum(lowDuration),
sum(bgRefreshSuc),
sum(bgRefreshFail),
sum(bTokenReq),
sum(bTokenSuc),
min(bTokenMin),
max(bTokenMax),
sum(bTokenAvg*bTokenSuc)/sum(bTokenSuc),
sum(tokenCleared)

FROM dragoLog
WHERE
datetime >= @period and
datetime < @stop and
rpl = 15
;

-- aggregation invasion
INSERT IGNORE INTO dragoLog_invasion (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,swTotal,swWarnSusp,swBanned,swSbanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,swConsecRPC,backoff)
SELECT
@period,
@rpl,
sum(rpc4),
sum(rpc5),
sum(rpc6),
sum(rpc7),
sum(rpc8),
sum(rpc9),
sum(rpc11),
sum(rpc12),
sum(rpc13),
sum(rpc14),
sum(rpc15),
sum(rpc16),
sum(rpc17),
sum(rpc18),
sum(swTotal),
sum(swWarnSusp),
sum(swBanned),sum(swSbanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(swStop), sum(swLLapi), sum(swQdist),sum(swConsecRPC),
sum(backoff)

FROM dragoLog_invasion
WHERE
datetime >= @period and
datetime < @stop and
rpl = 15
;

-- aggregation fort
INSERT IGNORE INTO dragoLog_fort (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,swTotal,swWarnSusp,swBanned,swSbanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,swConsecRPC,backoff)
SELECT
@period,
@rpl,
sum(rpc4),
sum(rpc5),
sum(rpc6),
sum(rpc7),
sum(rpc8),
sum(rpc9),
sum(rpc11),
sum(rpc12),
sum(rpc13),
sum(rpc14),
sum(rpc15),
sum(rpc16),
sum(rpc17),
sum(rpc18),
sum(swTotal),
sum(swWarnSusp),
sum(swBanned),sum(swSbanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(swStop), sum(swLLapi), sum(swQdist),sum(swConsecRPC),
sum(backoff)

FROM dragoLog_fort
WHERE
datetime >= @period and
datetime < @stop and
rpl = 15
;

-- settings
select @period := concat(date(now() - interval 10140 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 10140 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 60 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600));
select @rpl  := 10080;

-- aggregation area/generic
INSERT IGNORE INTO dragoLog (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,mitmUnknown,mitmNoGame,mitmLogginIn,mitmTokenRej,mitmNotLogged,mitmLoginErr,proxyBan,wsError,wsClose,wsMitmRecon,authReq,authed,login,swTotal,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,backoff,noAccount,released24h,released7d,minAuthT,maxAuthT,avgAuthT)
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
sum(mitmUnknown),
sum(mitmNoGame),
sum(mitmLogginIn),
sum(mitmTokenRej),
sum(mitmNotLogged),
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
sum(swBanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(swStop), sum(swLLapi), sum(swQdist),
sum(backoff),
sum(noAccount),
sum(released24h),
sum(released7d),
min(minAuthT),
max(maxAuthT),
sum(avgAuthT*authed)/sum(authed)

FROM dragoLog
WHERE
datetime >= @period and
datetime < @stop and
rpl = 1440
;

-- aggregation invasion
INSERT IGNORE INTO dragoLog_invasion (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,noGMO,gmoPoke,gmo0,gmo1,gmo2,gmo3,gmo4,gmo5,gmo6,gmo7,gmo8,swTotal,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,backoff)
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
sum(noGMO),
sum(gmoPoke),
sum(gmo0),
sum(gmo1),
sum(gmo2),
sum(gmo3),
sum(gmo4),
sum(gmo5),
sum(gmo6),
sum(gmo7),
sum(gmo8),
sum(swTotal),
sum(swWarnSusp),
sum(swBanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(swStop), sum(swLLapi), sum(swQdist),
sum(backoff)

FROM dragoLog_invasion
WHERE
datetime >= @period and
datetime < @stop and
rpl = 1440
;

-- aggregation fort
INSERT IGNORE INTO dragoLog_fort (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,swTotal,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,swStop,swLLapi,swQdist,backoff)
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
sum(swBanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(swStop), sum(swLLapi), sum(swQdist),
sum(backoff)

FROM dragoLog_fort
WHERE
datetime >= @period and
datetime < @stop and
rpl = 1440
;

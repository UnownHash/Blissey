-- settings
select @period := concat(date(now() - interval 15 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 15 minute)) DIV 900) * 900));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 900) * 900));
select @rpl  := 15;

-- aggregation area/generic
INSERT IGNORE INTO dragoLog (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,mitmUnknown,mitmNoGame,mitmLogginIn,mitmTokenRej,mitmNotLogged,mitmLoginErr,proxyBan,wsError,wsClose,wsMitmRecon,authReq,authed,login,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,backoff,noAccount,released24h,released7d)
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
sum(swWarnSusp),
sum(swBanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(backoff),
sum(noAccount),
sum(released24h),
sum(released7d)

FROM dragoLog
WHERE
datetime >= @period and
datetime < @stop and
rpl = 5
;

-- aggregation fort
INSERT IGNORE INTO dragoLog_fort (datetime,rpl,rpc4,rpc5,rpc6,rpc7,rpc8,rpc9,rpc11,rpc12,rpc13,rpc14,rpc15,rpc16,rpc17,rpc18,swWarnSusp,swBanned,swDisabled,swDayLimit,swRange,swTime,backoff)
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
sum(swWarnSusp),
sum(swBanned),
sum(swDisabled),
sum(swDayLimit),
sum(swRange),
sum(swTime),
sum(backoff)

FROM dragoLog_fort
WHERE
datetime >= @period and
datetime < @stop and
rpl = 5
;

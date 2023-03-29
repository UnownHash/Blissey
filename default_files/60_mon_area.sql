-- settings
select @period := concat(date(now() - interval 60 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 60 minute)) DIV 3600) * 3600));
select @stop :=  concat(date(now() - interval 0 minute),' ', SEC_TO_TIME((TIME_TO_SEC(time(now() - interval 0 minute)) DIV 3600) * 3600));
select @rpl  := 60;

-- process data
insert ignore into stats_mon_area (datetime,rpl,area,fence,totMon,ivMon,verifiedEnc,unverifiedEnc,verifiedReEnc,encSecLeft,encTthMax5,encTth5to10,encTth10to15,encTth15to20,encTth20to25,encTth25to30,encTth30to35,encTth35to40,encTth40to45,encTth45to50,encTth50to55,encTthMin55,resetMon,re_encSecLeft,numWiEnc,secWiEnc)
select
@period,
@rpl,
area,
fence,
sum(totMon),
sum(ivMon),
sum(verifiedEnc),
sum(unverifiedEnc),
sum(verifiedReEnc),
sum(encSecLeft),
sum(encTthMax5),
sum(encTth5to10),
sum(encTth10to15),
sum(encTth15to20),
sum(encTth20to25),
sum(encTth25to30),
sum(encTth30to35),
sum(encTth35to40),
sum(encTth40to45),
sum(encTth45to50),
sum(encTth50to55),
sum(encTthMin55),
sum(resetMon),
sum(re_encSecLeft),
sum(numWiEnc),
sum(secWiEnc)

from stats_mon_area

where
datetime >= @period and
datetime < @stop and
rpl = 15

group by area,fence
;

select * from (with total as (
	select
		sum(VALUE/100) cpu_usage_seconds_total
	from
		v$sesstat se,v$statname sn
	where
		se.STATISTIC# = sn.STATISTIC# and NAME like '%CPU used by this session%'
)
select
 ss.username,
 se.SID,
 VALUE/100 "CPU (s)",
 round(((value/100)*100)/tot.cpu_usage_seconds_total,2) "CPU %"
from
 v$session ss, v$sesstat se, v$statname sn, total tot
 where
	se.STATISTIC# = sn.STATISTIC#
	and  NAME like '%CPU used by this session%'
	and  se.SID = ss.SID
	and  ss.status='ACTIVE'
	and ss.username is not null
 order by 4 desc) where rownum<11;
select 
	trunc(begin_time,'MI') DIA,
	round(sum(case metric_name when 'Logons Per Sec' then average end),2) "Logons Per Sec",
	round(sum(case metric_name when 'Average Active Sessions' then average end),2) "AAS",	
	round(sum(case metric_name when 'SQL Service Response Time' then average end),2) "SQL Service Resp. Time",
	round(sum(case metric_name when 'User Transaction Per Sec' then average end),2) "Trx Per Sec",	
	round(sum(case metric_name when 'User Commits Per Sec' then average end),2) "Commits Per Sec",	
	round(sum(case metric_name when 'User Rollbacks Per Sec' then average end),2) "Rollbacks Per Sec"
from dba_hist_sysmetric_summary
where begin_time>trunc(sysdate)
group by trunc(begin_time,'MI')
order by 1;



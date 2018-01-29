select 
	trunc(begin_time,'MI') DIA,
	round(sum(case metric_name when 'Process Limit %' then average end),2) "Process Limit %",	
	round(sum(case metric_name when 'Session Limit %' then average end),2) "Session Limit %",
	round(sum(case metric_name when 'User Limit %' then average end),2) "User Limit %"
from dba_hist_sysmetric_summary
where begin_time>trunc(sysdate)
group by trunc(begin_time,'MI')
order by 1;


select 
	trunc(begin_time,'MI') DIA,
	round(sum(case metric_name when 'Long Table Scans Per Sec' then average end),2) "Long Table Scans Per Sec",	
	round(sum(case metric_name when 'Full Index Scans Per Sec' then average end),2) "Full Index Scans Per Sec",
	round(sum(case metric_name when 'Total Table Scans Per Sec' then average end),2) "Total Table Scans Per Sec",
	round(sum(case metric_name when 'Total Index Scans Per Sec' then average end),2) "Total Index Scans Per Sec"
from dba_hist_sysmetric_summary
where begin_time>trunc(sysdate)
group by trunc(begin_time,'MI')
order by 1;
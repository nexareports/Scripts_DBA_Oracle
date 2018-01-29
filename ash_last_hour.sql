

Select 
	trunc(sample_time,'HH24') Data,
	count(*) AS,
	round(sum(time_waited)/1000) "Time Waited(ms)"
from dba_hist_active_sess_history
where sample_time>sysdate-1/24
group by trunc(sample_time,'HH24')
order by 1;

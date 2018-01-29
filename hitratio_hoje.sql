select trunc(begin_time,'MI') Dia,
round(avg(case metric_name when 'Executions Per Sec' then average end),2) Execs_per_Sec,
round(avg(case metric_name when 'Buffer Cache Hit Ratio' then average end),2) Buffer_Cache_Hitratio,
round(avg(case metric_name when 'PGA Cache Hit %' then average end),2) "PGA Cache Hit %"
from dba_hist_sysmetric_summary
where begin_time>trunc(sysdate)
group by trunc(begin_time,'MI')
order by 1;
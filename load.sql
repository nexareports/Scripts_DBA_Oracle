alter session set nls_date_format='dd-mm-yyyy hh24:mi';
PROMPT #######################################################################################################################
PROMPT Load Profile:
PROMPT #######################################################################################################################
--Dia Hora
select min(begin_time), 
round(sum(case metric_name when 'Physical Read Total Bytes Per Sec' then average end)/1024/1024,2) Physical_Read_Total_MBps,
round(sum(case metric_name when 'Redo Generated Per Sec' then average end)/1024/1024,2) Redo_MBytes_per_sec,
round(sum(case metric_name when 'Current OS Load' then average end),2) OS_LOad,
round(sum(case metric_name when 'CPU Usage Per Sec' then average end),2) DB_CPU_Usage_per_sec,
round(sum(case metric_name when 'Host CPU Utilization (%)' then average end),2) Host_CPU_util,
snap_id
FROM DBA_HIST_SYSMETRIC_SUMMARY
where begin_time>trunc(sysdate)
group by snap_id
order by snap_id;

PROMPT #######################################################################################################################
PROMPT Hit Ratio:
PROMPT #######################################################################################################################
select trunc(begin_time,'MI') Dia,
round(avg(case metric_name when 'User Commits Per Sec' then average end),2) User_Commits,
round(avg(case metric_name when 'Executions Per Sec' then average end),2) Execs_per_Sec,
round(avg(case metric_name when 'Hard Parse Count Per Sec' then average end),2) Hard_Parsing_per_Sec,
round(avg(case metric_name when 'Parse Failure Count Per Sec' then average end),2) Parse_Failure,
round(avg(case metric_name when 'Buffer Cache Hit Ratio' then average end),2) Buffer_Cache_Hitratio
from dba_hist_sysmetric_summary
where begin_time>trunc(sysdate)
group by trunc(begin_time,'MI')
order by 1;
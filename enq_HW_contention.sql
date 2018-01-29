break on time
select to_char(sample_time,'YYYY-MM-DD HH24')||':00:00' time, sum(time_waited) time_waited, sesh.event, sql.sql_text
from DBA_HIST_ACTIVE_SESS_HISTORY sesh,
V$SQL sql
where sesh.sql_id=sql.sql_id
and trunc(sample_time,'HH24') >= to_date('20120704 00:00:00','yyyymmdd hh24:mi:ss')
and trunc(sample_time,'HH24') < to_date('20120704 12:00:00','yyyymmdd hh24:mi:ss') 
and sesh.event = 'enq: HW - contention'
group by to_char(sample_time,'YYYY-MM-DD HH24'), sesh.event, sql.sql_text
order by 1,2 desc;

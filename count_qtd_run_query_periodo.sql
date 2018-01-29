set lines 250
set pages 1000
set feed off

alter session set nls_date_format='DD-MM-YYYY HH24:MI'
/


select 	
	a.hash_value,
	max(a.fetches)-min(a.fetches) fetches,
	max(a.executions)-min(a.executions) executions,
	max(a.loads)-min(a.loads) loads,
        max(a.buffer_gets)-min(a.buffer_gets) buffer_gets,
	round(((max(a.elapsed_time)-min(a.elapsed_time))/(max(a.executions)-min(a.executions))/60000000)) elapsed_time_min
from 
	perfstat.stats$sql_summary                  a,
        perfstat.stats$snapshot                     b
where
        a.snap_id=b.snap_id    and
        a.hash_value=&1		and
        b.snap_time between '&2' and '&3'
group by
      a.hash_value
/

set feed on

alter session set nls_date_format='DD-MM-YYYY HH24:MI';

set feed off
set lines 250
set pages 1000

Prompt SQLS Mais Demorados entre &1 &2 e &3 &4
col module format a35


select 	
				a.hash_value,
				sum(a.fetches),
				sum(a.executions),
				sum(a.loads),
				sum(a.elapsed_time),
				round((sum(a.elapsed_time)/sum(a.executions))/60000000) uniq_tim
from 
		 		perfstat.STATS$SQL_SUMMARY                  a,
        perfstat.STATS$SNAPSHOT                     b
where
		 		a.executions>0         and
				a.elapsed_time>0       and
        a.snap_id=b.snap_id    and
        b.snap_time between '&1 &2' and '&3 &4'
Group by
        a.hash_value
order by 
				6 desc
				/
				
set feed on


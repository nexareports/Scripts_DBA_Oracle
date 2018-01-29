select AA.start_hour, 
       round(( 1-CC.phys_read/
       (AA.consistent_get + BB.db_blk_get))*100,1) buffer_hit_ratio
from (
 select 
  to_char(s.begin_interval_time, 'YYYY-MM-DD HH24') start_hour, 
  sum(e.value - b.value) consistent_get
  from
       dba_hist_sysstat b,
       dba_hist_sysstat e,
       dba_hist_snapshot s
  where b.snap_id = s.snap_id
   and  b.snap_id = e.snap_id -1
   and b.stat_id = 4162191256
   and b.stat_id = e.stat_id
   AND s.begin_interval_time >= trunc(SYSDATE)-1 
   --and s.begin_interval_time < trunc(sysdate) 
 group by  to_char(s.begin_interval_time, 'YYYY-MM-DD HH24')
 )  AA,
 (
 select to_char(s.begin_interval_time, 'YYYY-MM-DD HH24') start_hour, 
        sum(e.value - b.value) db_blk_get
  from
       dba_hist_sysstat b,
       dba_hist_sysstat e,
       dba_hist_snapshot s
  where b.snap_id = s.snap_id
   and  b.snap_id = e.snap_id -1
   and b.stat_id =1480709069 
   and b.stat_id = e.stat_id
   AND s.begin_interval_time >= trunc(SYSDATE)-1 
   --and s.begin_interval_time < trunc(sysdate) 
 group by to_char(s.begin_interval_time, 'YYYY-MM-DD HH24')
 ) BB,
 (
 select to_char(s.begin_interval_time, 'YYYY-MM-DD HH24') start_hour, 
        sum(e.value - b.value) phys_read 
  from
       dba_hist_sysstat b,
       dba_hist_sysstat e,
       dba_hist_snapshot s
  where b.snap_id = s.snap_id
   and  b.snap_id = e.snap_id -1
   and b.stat_id = 2263124246 
   and b.stat_id = e.stat_id
   AND s.begin_interval_time >= trunc(SYSDATE)-1 
   --and s.begin_interval_time < trunc(sysdate) 
 group by to_char(s.begin_interval_time, 'YYYY-MM-DD HH24')
 ) CC
where AA.start_hour=BB.start_hour
and   BB.start_hour=CC.start_hour
ORDER BY 1
/
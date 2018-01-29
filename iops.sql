column sri head "Small|Read|IOPS"
column swi head "Small|Write|IOPS"
column tsi head "Total|Small|IOPS"
column srp head "Small|Read|I/O%"
column swp head "Small|Write|I/O%"
column lri head "Large|Read|IOPS"
column lwi head "Large|Write|IOPS"
column tli head "Total|Large|IOPS"
column lrp head "Large|Read|I/O%"
column lwp head "Large|Write|I/O%"
column tr  head "Total|Read|MBPS"
column tw  head "Total|Written|MBPS"
column tm  head "Total|MBPS"
column begin_time for a25
column end_time for a25
SELECT end_time,
       ROUND(sr/inttime,3) sri,
       ROUND(sw/inttime,3) swi,
       ROUND((sr+sw)/inttime,3) tsi,
       ROUND(sr/DECODE((sr+sw),0,1,(sr+sw))*100,3) srp,
       ROUND(sw/DECODE((sr+sw),0,1,(sr+sw))*100,3) swp,
       ROUND(lr/inttime,3) lri,
       ROUND(lw/inttime,3) lwi,
       ROUND((lr+lw)/inttime,3) tli,
       ROUND(lr/DECODE((lr+lw),0,1,(lr+lw))*100,3) lrp,
       ROUND(lw/DECODE((lr+lw),0,1,(lr+lw))*100,3) lwp,
       ROUND((tbr/inttime)/1048576,3) tr,
       ROUND((tbw/inttime)/1048576,3) tw,
       ROUND(((tbr+tbw)/inttime)/1048576,3) tm
 FROM (
SELECT beg.snap_id beg_id, end.snap_id end_id, 
       beg.begin_interval_time, beg.end_interval_time, 
       end.begin_interval_time begin_time, end.end_interval_time end_time,
       (extract(day    from (end.end_interval_time - end.begin_interval_time))*86400)+
       (extract(hour   from (end.end_interval_time - end.begin_interval_time))*3600)+
       (extract(minute from (end.end_interval_time - end.begin_interval_time))*60)+
       (extract(second from (end.end_interval_time - end.begin_interval_time))*01) inttime,
       decode(end.startup_time,end.begin_interval_time,end.sr,(end.sr-beg.sr))    sr,
       decode(end.startup_time,end.begin_interval_time,end.sw,(end.sw-beg.sw))    sw,
       decode(end.startup_time,end.begin_interval_time,end.lr,(end.lr-beg.lr))    lr,
       decode(end.startup_time,end.begin_interval_time,end.lw,(end.lw-beg.lw))    lw,
       decode(end.startup_time,end.begin_interval_time,end.tbr,(end.tbr-beg.tbr)) tbr,
       decode(end.startup_time,end.begin_interval_time,end.tbw,(end.tbw-beg.tbw)) tbw
  FROM
(SELECT dba_hist_snapshot.snap_id, startup_time, begin_interval_time, end_interval_time,
 sum(decode(stat_name,'physical read total IO requests',value,0)- 
  decode(stat_name,'physical read total multi block requests',value,0)) sr,
 sum(decode(stat_name,'physical write total IO requests',value,0)- 
  decode(stat_name,'physical write total multi block requests',value,0)) sw,
 sum(decode(stat_name,'physical read total multi block requests',value,0)) lr,
 sum(decode(stat_name,'physical write total multi block requests',value,0)) lw,
 sum(decode(stat_name,'physical read total bytes',value,0)) tbr,
 sum(decode(stat_name,'physical write total bytes',value,0)) tbw
   FROM wrh$_sysstat, wrh$_stat_name, dba_hist_snapshot
  WHERE wrh$_sysstat.stat_id = wrh$_stat_name.stat_id
    AND wrh$_sysstat.snap_id = dba_hist_snapshot.snap_id
  group by dba_hist_snapshot.snap_id, startup_time, begin_interval_time, end_interval_time) beg,
(SELECT dba_hist_snapshot.snap_id, startup_time, begin_interval_time, end_interval_time,
 sum(decode(stat_name,'physical read total IO requests',value,0)- 
  decode(stat_name,'physical read total multi block requests',value,0)) sr,
 sum(decode(stat_name,'physical write total IO requests',value,0)- 
  decode(stat_name,'physical write total multi block requests',value,0)) sw,
 sum(decode(stat_name,'physical read total multi block requests',value,0)) lr,
 sum(decode(stat_name,'physical write total multi block requests',value,0)) lw,
 sum(decode(stat_name,'physical read total bytes',value,0)) tbr,
 sum(decode(stat_name,'physical write total bytes',value,0)) tbw
   FROM wrh$_sysstat, wrh$_stat_name, dba_hist_snapshot
  WHERE wrh$_sysstat.stat_id = wrh$_stat_name.stat_id
    AND wrh$_sysstat.snap_id = dba_hist_snapshot.snap_id
  group by dba_hist_snapshot.snap_id, startup_time, begin_interval_time, end_interval_time) end
 WHERE beg.snap_id + 1 = end.snap_id
)
order by 1
/
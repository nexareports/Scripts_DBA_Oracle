select   fs.snap_id,fs.instance_number, sn.BEGIN_INTERVAL_TIME, count(*)
from     SYS.WRH$_ACTIVE_SESSION_HISTORY fs, SYS.DBA_HIST_snapshot sn
where    fs.snap_id = sn.snap_id
and      fs.dbid = sn.dbid
and      fs.instance_number = sn.instance_number
and fs.snap_id in (14335)
group by fs.snap_id,fs.instance_number, sn.BEGIN_INTERVAL_TIME
order by fs.snap_id, fs.instance_number
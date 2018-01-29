Select to_char(a.begin_interval_time,'DD-MM-YYYY HH24:MI') Data,b.value
From dba_hist_snapshot a, dba_hist_sysstat b
WHERE A.SNAP_ID=B.SNAP_ID AND B.STAT_NAME='logons current'
and a.begin_interval_time>trunc(sysdate)-10
Order by 1 desc ;

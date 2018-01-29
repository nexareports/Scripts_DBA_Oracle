select
   srt.tablespace,
   srt.segfile#,
   srt.segblk#,
   srt.blocks,
   a.sid,
   a.serial#,
   a.username,
   a.osuser,
   a.status
from
   v$session    a,
   v$sort_usage srt 
where
   a.saddr = srt.session_addr 
order by
   srt.tablespace, srt.segfile#, srt.segblk#,
   srt.blocks;
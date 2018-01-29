COLUMN username FORMAT A15
break on report
compute sum label 'TOTAL' of undo_kb on report
SELECT s.inst_id,
           s.username,
       s.sid,
       s.serial#,
trunc(t.used_ublk * TO_NUMBER(x.value)/1024/1024,2) AS undo_mb,
       t.used_urec,
           rs.tablespace_name,
       rs.segment_name,
       r.rssize,
       r.status
--,      sum(e.bytes)/1024/1024 "SIZE(MB)"
FROM   gv$transaction t,
       gv$session s,
       gv$rollstat r,
       dba_rollback_segs rs,
       v$parameter x
--,      dba_undo_extents e
WHERE  s.inst_id = t.inst_id
AND    t.inst_id = r.inst_id
AND    s.saddr = t.ses_addr
AND    t.xidusn = r.usn
AND    rs.segment_id = t.xidusn
AND    x.name = 'db_block_size'
/*AND    e.segment_name = rs.segment_name
GROUP BY s.username,
       s.sid,
       s.serial#,
       t.used_ublk,
       t.used_urec,
       r.status*/
ORDER BY t.used_ublk DESC;

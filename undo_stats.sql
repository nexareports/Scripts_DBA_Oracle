prompt ############ Active blocks of undo segments ###############
select status , sum(blocks)*&block_size/1024/1024/1024 GB 
from dba_undo_extents 
group by status;

prompt ############ Transaction blocks used and rssize used ###############
show parameter block_size
accept block_size prompt block_size? 

SELECT s.sid, s.username,t.used_ublk*&block_size/1024/1024/1024 used_ublk_GB,t.used_urec,rs.segment_name,r.rssize/1024/1024/1024 rssize_GB,r.status
FROM   v$transaction t,  v$session s,v$rollstat r, dba_rollback_segs rs                                 
WHERE  s.saddr = t.ses_addr AND    t.xidusn = r.usn AND   rs.segment_id = t.xidusn 
ORDER BY t.used_ublk DESC; 

prompt ############## Total segment size of undo segment ###################
select tablespace_name, segment_name, bytes/1024/1024/1024 GB 
from dba_segments 
where segment_type like '%UNDO%'
order by tablespace_name, segment_name;         

prompt ############## No pending transations ###################
select usn, UNDOBLOCKSDONE, UNDOBLOCKSTOTAL, pid 
from v$fast_start_transactions;                     

SELECT A.SID, A.USERNAME, B.XIDUSN, B.USED_UREC, B.USED_UBLK
FROM V$SESSION A, V$TRANSACTION B
WHERE A.SADDR=B.SES_ADDR;

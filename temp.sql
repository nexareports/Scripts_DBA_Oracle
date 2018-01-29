col sql_text for a60

select (s.tot_used_blocks/f.total_blocks)*100 as "percent used"
from (select sum(used_blocks) tot_used_blocks from v$sort_segment where tablespace_name='TEMP') s, (select sum(blocks) total_blocks from dba_temp_files where tablespace_name='TEMP') f;


SELECT a.username, a.sid, a.serial#, a.osuser, b.tablespace, b.blocks, c.sql_text
FROM v$session a, v$tempseg_usage b, v$sqlarea c
WHERE a.saddr = b.session_addr
AND c.address= a.sql_address
AND c.hash_value = a.sql_hash_value
ORDER BY b.tablespace, b.blocks;

SELECT S.username, T.tablespace,Q.sql_text,
sum(T.blocks * TBS.block_size / 1024 / 1024) mb_used
FROM v$sort_usage T, v$session S, v$sqlarea Q, dba_tablespaces TBS
WHERE T.session_addr = S.saddr
AND T.sqladdr = Q.address (+)
AND T.tablespace = TBS.tablespace_name
group by S.username, T.tablespace,Q.sql_text
ORDER BY 4 desc; 




col sql_text clear
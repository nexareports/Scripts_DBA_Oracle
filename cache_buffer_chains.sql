select * from (
select CHILD#  cCHILD
,      ADDR    sADDR
,      GETS    sGETS
,      MISSES  sMISSES
,      SLEEPS  sSLEEPS 
from v$latch_children 
where name = 'cache buffers chains'
order by 5 desc , 1, 2, 3)
where rownum <11;




prompt column segment_name format a35
prompt select /*+ RULE */
prompt e.owner ||'.'|| e.segment_name  segment_name,
prompt e.extent_id  extent#,
prompt x.dbablk - e.block_id + 1  block#,
prompt x.tch,
prompt l.child#
prompt from
prompt sys.v$latch_children  l,
prompt sys.x$bh  x,
prompt sys.dba_extents  e
prompt where
prompt x.hladdr  = 'sADDR' and
prompt e.file_id = x.file# and
prompt x.hladdr = l.addr and
prompt x.dbablk between e.block_id and e.block_id + e.blocks -1
prompt order by x.tch desc ;
prompt
prompt


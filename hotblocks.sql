with tmp as (Select * from (
	select CHILD#  "cCHILD"
     ,      ADDR    "sADDR"
     ,      GETS    "sGETS"
     ,      MISSES  "sMISSES"
     ,      SLEEPS  "sSLEEPS" 
     from v$latch_children 
     where name = 'cache buffers chains'
     order by 5 desc, 1, 2, 3) where rownum<6)
select /*+ RULE */
       e.owner ||'.'|| e.segment_name  segment_name,
       e.extent_id  extent#,
       x.dbablk - e.block_id + 1  block#,
       x.tch,
       l.child#,
	   t."sGETS",
	   t."sMISSES",
	   t."sSLEEPS" 
     from
       sys.v$latch_children  l,
       sys.x$bh  x,
       sys.dba_extents  e,
	   tmp t
     where
       x.hladdr  = t."sADDR" and
       e.file_id = x.file# and
       x.hladdr = l.addr and
       x.dbablk between e.block_id and e.block_id + e.blocks -1
     order by x.tch desc ;
	 
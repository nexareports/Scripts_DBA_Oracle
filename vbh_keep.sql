SELECT b.inst_id, do.owner, do.object_name, do.object_type, COUNT(b.block#) "Cached Blocks", ds.buffer_pool, b.status
FROM gv$bh b, dba_objects do, dba_segments ds
WHERE b.OBJD = do.data_object_id
AND do.object_name = ds.segment_name
and do.object_name='LSW_TASK'--and ds.buffer_pool='KEEP'
GROUP BY b.inst_id, do.owner, do.object_name, do.object_type, ds.buffer_pool,  b.status
ORDER BY 2, 3, 1;
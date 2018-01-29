
Prompt Our Aim: OLTP >= 95%, DSS/Batch >= 85%

select name,block_size, ((consistent_gets + db_block_gets) - physical_reads) /
(consistent_gets + db_block_gets) * 100 "Hit Ratio%"
from v$buffer_pool_statistics
where physical_reads > 0;


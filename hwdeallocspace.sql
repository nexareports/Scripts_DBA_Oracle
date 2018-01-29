define V_BLK_DIV=128    /* value of 128 implies DB_BLOCK_SIZE = 8192 */

select  f.file_name,
        sum(nvl(e.blocks,0))/128 sum_mb,
        max(nvl(e.block_id,0)+nvl(e.blocks,0))/128 highest_mb,
        f.blocks/128 tot_mb
from    dba_extents e,
        dba_data_files f
where   f.tablespace_name = upper('&1')
and     e.tablespace_name (+) = f.tablespace_name
and     e.file_id (+) = f.file_id
group by f.file_name,
         f.blocks/128
/

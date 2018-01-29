select last_analyzed,num_rows,SAMPLE_SIZE*100/num_rows Sample_Size,blocks,pct_free,ini_trans,freelists,buffer_POOL,PARTITIONED
from dba_tables
where owner='&1' and table_name='&2';

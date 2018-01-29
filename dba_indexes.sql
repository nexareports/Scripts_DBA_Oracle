select table_name,last_analyzed,num_rows,SAMPLE_SIZE*100/num_rows Sample_Size,pct_free,ini_trans,freelists,buffer_POOL,FUNCIDX_STATUS,Status
from dba_indexes
where owner='&1' and index_name='&2';

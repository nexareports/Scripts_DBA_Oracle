Select column_name,NUM_DISTINCT,NUM_NULLS,NUM_BUCKETS,GLOBAL_STATS,HISTOGRAM from dba_tab_col_statistics where owner='&1' and table_name='&2' order by 1;

Select column_name,HISTOGRAM,DATA_TYPE from dba_tab_cols where owner='&1' and table_name='&2' order by 1;
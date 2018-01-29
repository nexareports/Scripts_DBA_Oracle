Select /* PARA PROCURAR O INTERVALO */snap_id,begin_interval_time from dba_hist_snapshot where begin_interval_time>trunc(sysdate-1) order by 1;  

Prompt @ash_sql_impact [1] [2]
Prompt @ash_profile [1] [2]
Prompt @ash_top_event [1] [2]
prompt
prompt
select TABLE_NAME, STATS_UPDATE_TIME 
from dba_tab_stats_history 
where table_name='S_EVT_ACT'

execute DBMS_STATS.RESTORE_TABLE_STATS ('SIEBEL','S_EVT_ACT','09.09.17 13:43:38,781891 +01:00');


select b.* --owner, table_name, stattype_locked 
from dba_tab_statistics a, dba_tables b
where a.owner='PGSBLDB'
and a.owner=b.owner
and a.table_name=b.table_name
--and table_name='CX_EFICOMERCACC'
and stattype_locked is not null;
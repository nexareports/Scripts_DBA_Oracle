select extract( day from snap_interval) *24*60+extract( hour from snap_interval) *60+extract( minute from snap_interval ) snapshot_interval,
extract( day from retention) *24*60+extract( hour from retention) *60+extract( minute from retention ) retention_interval,
topnsql
from dba_hist_wr_control;


execute dbms_workload_repository.modify_snapshot_settings(interval => 60, retention => 64800);
   

select extract( day from snap_interval) *24*60+extract( hour from snap_interval) *60+extract( minute from snap_interval ) snapshot_interval,
extract( day from retention) +extract( hour from retention) *60+extract( minute from retention ) retention_interval,
topnsql
from dba_hist_wr_control;


SELECT 
  snap_id, begin_interval_time, end_interval_time 
FROM 
  SYS.WRM$_SNAPSHOT 
WHERE 
  snap_id = ( SELECT MIN (snap_id) FROM SYS.WRM$_SNAPSHOT)
UNION 
SELECT 
  snap_id, begin_interval_time, end_interval_time 
FROM 
  SYS.WRM$_SNAPSHOT 
WHERE 
  snap_id = ( SELECT MAX (snap_id) FROM SYS.WRM$_SNAPSHOT)
/
   
   
BEGIN                                                               
  dbms_workload_repository.drop_snapshot_range(low_snap_id => 7556, high_snap_id=>9271);                                         
END;
/



--Recreate AWR Metalink note Doc ID: 852028.1  (necessita de restart à instância [ID 984447.1])
SQL> connect / as sysdba 
SQL> @?/rdbms/admin/catnoawr.sql 
SQL> @?/rdbms/admin/catawrtb.sql 

How to Recreate The AWR ( AUTOMATIC WORKLOAD ) Repository ? [ID 782974.1]

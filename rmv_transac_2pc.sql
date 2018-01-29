--set lines 250
--set pages 1000

select 
'commit;'||chr(10)||'alter session set "_smu_debug_mode" = 4;'||chr(10)||
'exec DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('''||LOCAL_TRAN_ID||''');'||chr(10)||'commit;'
from dba_2pc_pending where STATE='forced rollback';


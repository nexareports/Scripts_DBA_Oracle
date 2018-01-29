
SELECT 
  a.name,b.incremental_level,b.pieces,
  b.start_time,b.completion_time,b.controlfile_included 
from    rman.rc_backup_--set b ,rman.rc_database a
where b.start_time between sysdate-1 and sysdate
and b.incremental_level is not null and a.dbid=b.db_id
/



SELECT 
  a.name,b.incremental_level,count(b.pieces),min(b.start_time),max(b.completion_time)
 from    rman.rc_backup_--set b ,rman.rc_database a
where b.start_time between sysdate-4 and sysdate
and b.incremental_level is not null and a.dbid=b.db_id
group by a.name,b.incremental_level
/


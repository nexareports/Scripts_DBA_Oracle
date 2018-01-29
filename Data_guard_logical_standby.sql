select * from DBA_LOGSTDBY_EVENTS order by  1 desc;
SELECT * FROM GV$LOGSTDBY order by 4;
select statement_opt, name from dba_logstdby_skip;

select distinct object_name from dba_objects where object_name like 'DBA_LOGSTDBY%'

SELECT DEST_ID "ID",
       STATUS "DB_status",
       DESTINATION "Archive_dest",
       ERROR "Error"
  FROM GV$ARCHIVE_DEST
WHERE DESTINATION IS NOT NULL;

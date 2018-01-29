SELECT sequence#, first_time, next_time, applied
FROM   v$archived_log where first_time>trunc(sysdate)-1 --and applied!='YES'
ORDER BY sequence#;

col dest_name for a20
col status for a15
col ERROR for a20
col DESTINATION for a30
col DB_UNIQUE_NAME for a15
select DEST_NAME,STATUS,ERROR,DB_UNIQUE_NAME,DESTINATION from v$archive_dest_Status where status!='INACTIVE';

--select process, status,sequence#,block#,blocks, delay_mins from v$managed_standby;

select START_TIME,TYPE, ITEM,UNITS,SOFAR,TIMESTAMP
from v$recovery_progress where ITEM='Last Applied Redo';

/*
SELECT ARCH.THREAD# "Thread", ARCH.SEQUENCE# "Last Sequence Received", APPL.SEQUENCE# "Last Sequence Applied", (ARCH.SEQUENCE# - APPL.SEQUENCE#) "Difference"
FROM
(SELECT THREAD# ,SEQUENCE# FROM V$ARCHIVED_LOG WHERE (THREAD#,FIRST_TIME ) IN (SELECT THREAD#,MAX(FIRST_TIME) FROM V$ARCHIVED_LOG GROUP BY THREAD#)) ARCH,
(SELECT THREAD# ,SEQUENCE# FROM V$LOG_HISTORY WHERE (THREAD#,FIRST_TIME ) IN (SELECT THREAD#,MAX(FIRST_TIME) FROM V$LOG_HISTORY GROUP BY THREAD#)) APPL
WHERE
ARCH.THREAD# = APPL.THREAD#
ORDER BY 1;*/

col dest_name clear
col status clear
col ERROR clear
col DESTINATION clear
col DB_UNIQUE_NAME clear
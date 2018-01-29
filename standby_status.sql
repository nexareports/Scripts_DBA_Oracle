set lines 250 pages 100
col dest_name for a20
col status for a15
col ERROR for a20
col DESTINATION for a30
col DB_UNIQUE_NAME for a15
ALTER SESSION SET nls_date_format='DD-MON-YYYY HH24:MI:SS';
select DEST_NAME,STATUS,ERROR,DB_UNIQUE_NAME,DESTINATION from v$archive_dest_Status where status!='INACTIVE';


SELECT sequence#, first_time, next_time FROM v$archived_log where first_time > sysdate-1/24 ORDER BY sequence#;
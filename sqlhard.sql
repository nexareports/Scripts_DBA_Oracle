set feedback off;
set lines 250;
set pages 1000;
select HASH_VALUE,ELAPSED_TIME,EXECUTIONS,DISK_READS from v$sqlarea
where rownum <=10
order by ELAPSED_TIME DESC;
set feedback on;
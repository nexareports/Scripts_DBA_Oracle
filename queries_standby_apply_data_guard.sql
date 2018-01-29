set lines 300 pages 1000
col name format a100
select sequence#, applied, to_char(first_time,'yyyy-mm-dd hh24:mi:ss'), name, dest_id from v$archived_log where first_time > sysdate -1 order by 3;

SELECT  PROCESS, STATUS,SEQUENCE#,BLOCK#,BLOCKS, DELAY_MINS 
FROM V$MANAGED_STANDBY;

select destination, status, archived_thread#, archived_seq# from v$archive_dest_status;
select process, status from v$managed_standby;
select open_mode from v$database;






MONITORIZAÇÃO
select process, status from v$managed_standby
where process like '%MRP%';

select decode(status,'WAIT_FOR_LOG',1,0) + decode(status,'APPLYING_LOG',1,0) status 
from v$managed_standby
where process like '%MRP%';


set serveroutput on;
declare
message varchar2(200);
begin
select decode(status,'WAIT_FOR_LOG',1,0) + decode(status,'APPLYING_LOG',1,0) status into message from v$managed_standby where process like '%MRP%';
dbms_output.put_line ('status '||message);
end;
/
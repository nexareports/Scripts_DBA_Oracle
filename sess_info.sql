column sse            format a15
COLUMN os_pid         format a10    HEADING 'O/S PID'         JUSTIFY left
column osuser         format a20
column program        format a40
column module         format a40
column machine        format a30
column "ELAPSED TIME" format a12
column db_cmd         format a50    HEADING 'Database Kill Session' JUSTIFY left
column so_cmd         format a20    HEADING 'SO Kill Session'       JUSTIFY left
column logon_time     format a20 

SET LINESIZE 400
--SET LINESIZE 160
SET PAGESIZE 9999
set verify off

SELECT ''''||b.sid||','||b.serial#||'''' sse
     , a.SPID os_pid
     , b.username
     , b.osuser
     , to_char(b.logon_time, 'YYYY-MM-DD HH24:MI:SS') logon_time
     , lpad(trunc(b.LAST_CALL_ET/86400),2,0)||' '||
       lpad(trunc((b.LAST_CALL_ET/86400-trunc(b.LAST_CALL_ET/86400))*24),2,0)||':'||
       lpad (trunc((b.LAST_CALL_ET/3600-trunc(b.LAST_CALL_ET/3600))*60),2,0)||':'||
       lpad(trunc(((b.LAST_CALL_ET/3600-trunc(b.LAST_CALL_ET/3600))*60-trunc((b.LAST_CALL_ET/3600-trunc(b.LAST_CALL_ET/3600))*60))*60),2,0)"ELAPSED TIME"
     , b.status
     , b.sql_address
     , b.sql_hash_value
     , b.sql_id
     , b.PREV_SQL_ID
     , SUBSTR (b.program, 1, 30 ) program
     , b.module
     , b.machine
     , 'alter system kill session ''' || b.Sid || ',' || b.Serial# || ''' immediate;' db_cmd
     , 'kill -9  ' || a.SPID ||';' so_cmd
  From V$session b, V$process a
 Where b.Paddr = a.Addr
   AND b.sid      like nvl('&sid',b.sid)
   AND b.username like nvl('&username', b.username)
   AND b.osuser   like nvl('&osuser', b.osuser)
   AND a.SPID      like nvl('&SPID',a.SPID)
/

set verify on
prompt
prompt
prompt
prompt. @sqltxtsid <sid>     @sqltxta <sql_address>    @sqltxth <sql_hash_value>     @sqltxtsqlid <sql_id> 
prompt. @showsql1            @showsql2                 @sqltxtfulltext <sql_id>
prompt. @sess_users          @sess_user_stats          @sess_user_sessions 
prompt



--set lines 250
--set pages 1000
col sess format a10
COLUMN progress_pct FORMAT 99999999.00
COLUMN username FORMAT A10
COLUMN message FORMAT A80
column program format a35
--set verify off
--set head off
--set feed off

--alter session set nls_date_format='DD-MM-YYY HH24:MI';

select 
'Sid, Serial#, Aud sid : '||s.sid||' , '||s.serial#||' , '||s.audsid||chr(10)||
'DB User / OS User : '||s.username||'   /   '||s.osuser||chr(10)||
'Machine - Terminal : '||s.machine||'  -  '||s.terminal||chr(10)||
'OS Process Ids : '||s.process||' (PROCESS Cli)  '||p.spid||' (OSPID)'||chr(10)||
'Client Program Name : '||s.program||chr(10)||
'Logon time: '||to_char(s.logon_time,'DD-MM-YYYY HH24:MI:SS')||'   Last Call ET (min): '||to_char(round(s.last_call_et/60,2))||chr(10)||
--'WAITS:'||to_char(s.seconds_in_wait)||'(s)'||chr(10)||
'Wait Event: '||s.event||chr(10)||
--'P1Text: '||s.p1text||' '||to_char(s.p1)||' P2Text: '||s.p2text||' '||to_char(s.p2)||chr(10)||
'WAIT_OBJ '||to_char(ROW_WAIT_OBJ#)||' WAIT_FILE '||to_char(ROW_WAIT_FILE#)||' WAIT_BLOCK '||to_char(ROW_WAIT_BLOCK#)||chr(10)||
'SQL Active: '||to_char(s.sql_id)||' Prev SQL: '||to_char(s.prev_sql_id)||chr(10)||
'Client Info: '||client_info||chr(10)||
'alter system kill session '||chr(39)||s.sid||','||s.serial#||chr(39)||'; kill -9 '||p.spid "Session Info"
from v$process p,v$session s
where s.sid=&1 and s.serial#=&2 and p.addr=s.paddr;

Select unique
	'AUTHENTICATION_TYPE: '||AUTHENTICATION_TYPE||chr(10)||
	'NETWORK_SERVICE_BANNER: '||NETWORK_SERVICE_BANNER||chr(10)||
	'CLIENT_CHARSET: '||CLIENT_CHARSET||chr(10)||
	'CLIENT_CONNECTION: '||CLIENT_CONNECTION||chr(10)||
	'CLIENT_OCI_LIBRARY: '||CLIENT_OCI_LIBRARY||chr(10)||
	'CLIENT_VERSION: '||CLIENT_VERSION||chr(10)||
	'CLIENT_DRIVER: '||CLIENT_DRIVER||chr(10)||
	'CLIENT_LOBATTR: '||CLIENT_LOBATTR||chr(10)||
	'CLIENT_REGID: '||CLIENT_REGID CLIENT_INFO
from V$SESSION_CONNECT_INFO
where sid=&1 and serial#=&2;
    
set feed on
set head on
PROMPT
PROMPT @sid_history &1 serial#
PROMPT @sid2
PROMPT

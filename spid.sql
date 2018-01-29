--set lines 250
--set pages 1000
col sess format a10
COLUMN progress_pct FORMAT 99999999.00
COLUMN username FORMAT A10
COLUMN message FORMAT A80
column program format a35
--set verify off
--set feed off

alter session set nls_date_format='DD-MM-YYY HH24:MI';

select a.sid,a.machine,a.serial#,a.username,a.status,a.sql_hash_value,a.program,a.logon_time,round(a.last_call_et/60)
min_sfpn from v$session a, v$process b
where a.paddr=b.addr
and spid=&1
/

prompt _________________________________________________________________________
prompt @count_qtd_run_query_periodo [SQL_HASH  DATA_INICIO  DATA_FINAL] - DATA ENTRE PLICAS/ASPAS
prompt @infouser [SID]
prompt @sqltext

--set feed on
--set verify on

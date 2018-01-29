col name for a20
select 'SESSIONS' NAME, count(1) NUM_STUFF from v$session union all select 'PROCESS', count(1) from v$process;
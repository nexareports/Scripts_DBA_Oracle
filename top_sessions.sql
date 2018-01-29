col username format a15
col machine format a15
Prompt OPCOES: READS, EXECS ou CPU
Prompt
select * from (
SELECT NVL(a.username, '(oracle)') AS username,
       a.sid,
       c.value AS OPT,
       a.lockwait,
       a.status,
       a.machine,
       TO_CHAR(a.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   v$session a,
       v$sesstat c,
       v$statname d
WHERE  a.sid        = c.sid
AND    c.statistic# = d.statistic#
AND    d.name       = DECODE(UPPER('&opt'), 'READS', 'session logical reads',
                                          'EXECS', 'execute count',
                                          'CPU',   'CPU used by this session',
                                                   'CPU used by this session')
ORDER BY c.value DESC) where rownum<11;

col username clear
col machine clear

@__conf
set pages 1000
set lines 250

SELECT s.sid,
       s.status,
       s.process,
       s.schemaname,
       s.osuser,
       a.sql_text,
       p.program
FROM   v$session s,
       v$sqlarea a,
       v$process p
WHERE  s.SQL_HASH_VALUE = a.HASH_VALUE
AND    s.SQL_ADDRESS = a.ADDRESS
AND    s.PADDR = p.ADDR
and    s.sid=&1
/

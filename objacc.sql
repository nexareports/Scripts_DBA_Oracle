set lines 250 pages 1000
col comando format a40;
col object format a20;
SELECT 'alter system kill session '||chr(39)||b.sid||','||b.serial#||chr(39)||';' Comando,
       a.object,
       a.type,
       b.username
FROM   v$access a,
       v$session b
WHERE  a.sid   = b.sid
AND    a.owner = upper('&OWNER_')
AND    a.object like upper('%&OBJETO%')
ORDER BY a.object
/

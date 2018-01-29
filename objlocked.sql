--set LINESIZE 500
--set PAGESIZE 1000
--set VERIFY OFF
--set feedback off

COLUMN owner FORMAT A20
COLUMN username FORMAT A20
COLUMN object_owner FORMAT A20
COLUMN object_name FORMAT A30
COLUMN locked_mode FORMAT A15
col sid format a10

SELECT to_char(b.session_id) AS sid,
       NVL(b.oracle_username, '(oracle)') AS username,
       a.owner AS object_owner,
       a.object_name,
       Decode(b.locked_mode, 0, 'None',
                             1, 'Null (NULL)',
                             2, 'Row-S (SS)',
                             3, 'Row-X (SX)',
                             4, 'Share (S)',
                             5, 'S/Row-X (SSX)',
                             6, 'Exclusive (X)',
                             b.locked_mode) locked_mode,
       b.os_user_name
FROM   dba_objects a,
       v$locked_object b
WHERE  a.object_id = b.object_id
ORDER BY 1, 2, 3, 4;

--set PAGESIZE 14
--set VERIFY ON
--set feedback on
@__conf
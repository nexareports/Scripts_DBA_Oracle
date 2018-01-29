--set LINESIZE 500
COLUMN "Hit Ratio %" FORMAT 999.99
--set feed off
--set verify off
--set Sid format a8

Prompt TOP USERS BUFFER GETS / HIT RATIO

Select * from (
SELECT to_char(a.sid) Sid,
       b.consistent_gets "Consistent Gets",
       b.block_gets "DB Block Gets",
       b.physical_reads "Physical Reads",
       Round(100* (b.consistent_gets + b.block_gets - b.physical_reads) /
       (b.consistent_gets + b.block_gets),2) "Hit Ratio %"
FROM   v$session a,
       v$sess_io b
WHERE  a.sid = b.sid
AND    (b.consistent_gets + b.block_gets) > 0
AND    a.username IS NOT NULL
order by 5 ) where rownum<10+1;

--set feed on
--set verify on


--set LINESIZE 130
--set PAGESIZE 66

COLUMN Object   FORMAT a30     HEADING 'Object' 
COLUMN Type     FORMAT a4      HEADING 'Type'
COLUMN UserID   FORMAT a20     HEADING 'OS/Oracle' 
COLUMN Hold     FORMAT a10     HEADING 'Hold' 
COLUMN Program  FORMAT a35     HEADING 'Program' 
COLUMN usercode FORMAT a12     HEADING 'SID/Serial#' 
COLUMN WaitMin  FORMAT 999,999 HEADING 'Wait Time (minutes)' 

SELECT 
    a.osuser || ':' || a.username   UserID
  , a.sid || '/' || a.serial#       usercode
  , b.lock_type Type, b.mode_held   Hold
  , c.owner || '.' || c.object_name Object
  , ROUND(d.seconds_in_wait/60,2)   WaitMin
  , a.sql_hash_value
FROM 
    v$session       a
  , dba_locks   b
  , dba_objects c
  , v$session_wait  d
WHERE 
      a.sid        =  b.session_id
  AND b.lock_type  IN ('DML','DDL')
  AND b.lock_id1   =  c.object_id
  AND b.session_id  =  d.sid
order by 2
/


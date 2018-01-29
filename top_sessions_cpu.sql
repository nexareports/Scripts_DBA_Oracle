
--set LINESIZE 145
--set PAGESIZE 9999
col sid clear
COLUMN sid               FORMAT 999              HEADING 'SID'
COLUMN serial_id         FORMAT 999999           HEADING 'Serial#'
COLUMN session_status    FORMAT a9               HEADING 'Status'          JUSTIFY right
COLUMN oracle_username   FORMAT a12              HEADING 'Oracle User'     JUSTIFY right
COLUMN os_username       FORMAT a9               HEADING 'O/S User'        JUSTIFY right
COLUMN os_pid            FORMAT 9999999          HEADING 'O/S PID'         JUSTIFY right
COLUMN session_program   FORMAT a20              HEADING 'Session Program' TRUNC
COLUMN session_machine   FORMAT a14              HEADING 'Machine'         JUSTIFY right TRUNC
COLUMN cpu_value         FORMAT 999,999,999,999  HEADING 'CPU'

prompt 
prompt +----------------------------------------------------+
prompt | User Sessions Ordered by CPU                       |
prompt +----------------------------------------------------+

Select * from (
SELECT
    s.sid                sid
  , s.serial#            serial_id
  , lpad(s.status,9)     session_status
  , lpad(s.username,12)  oracle_username
  , lpad(s.osuser,9)     os_username
  , lpad(p.spid,7)       os_pid
  , s.program            session_program
  , lpad(s.machine,14)   session_machine
  , sstat.value          cpu_value
FROM 
    v$process  p
  , v$session  s
  , v$sesstat  sstat
  , v$statname statname
WHERE
      p.addr (+)          = s.paddr
  AND s.sid               = sstat.sid
  AND statname.statistic# = sstat.statistic#
  AND statname.name       = 'CPU used by this session'
  and s.username is not null
ORDER BY cpu_value DESC) where rownum<&1+1
/

prompt __________________________
prompt @infouser

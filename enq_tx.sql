Prompt Hold Lock (Latch):
Prompt
select 
ADDR "ADDR obj",
KADDR,
SID,inst_id,
TYPE,
ID1,
ID2,
decode(LMODE,1,'NULL',2,'row-S',3,'row-X',4,'S',5,'S/Row-X',6,'Exc') LMODE,
decode(REQUEST,1,'NULL',2,'row-S',3,'row-X',4,'S',5,'S/Row-X',6,'Exc') REQUEST,
CTIME "CTIME (s)",
BLOCK
from gv$lock where type='TX' and lmode>0
order by ctime desc;

COLUMN sid                     FORMAT 99999              HEADING 'SID'
COLUMN serial_id               FORMAT 99999999         HEADING 'Serial ID'
COLUMN session_status          FORMAT a9               HEADING 'Status'          JUSTIFY right
COLUMN oracle_username         FORMAT a14              HEADING 'Oracle User'     JUSTIFY right
COLUMN os_username             FORMAT a12              HEADING 'O/S User'        JUSTIFY right
COLUMN os_pid                  FORMAT 9999999          HEADING 'O/S PID'         JUSTIFY right
COLUMN trnx_start_time         FORMAT a18              HEADING "Trnx Start Time" JUSTIFY right
COLUMN current_time            FORMAT a18              HEADING "Current Time"
COLUMN elapsed_time            FORMAT 999999999.99     HEADING "Elapsed(m)"
COLUMN undo_name               FORMAT a9               HEADING "Undo Name"       JUSTIFY right
COLUMN number_of_undo_records  FORMAT 999,999,999,999  HEADING "# Undo Records"
COLUMN used_undo_blks          FORMAT     999,999,999  HEADING "Used Undo Blks" 
COLUMN used_undo_size          FORMAT 999,999,999,999  HEADING  "Used Undo Size"
COLUMN logical_io_blks         FORMAT     999,999,999  HEADING  "Logical I/O (Blks)"
COLUMN logical_io_size         FORMAT 999,999,999,999  HEADING  "Logical I/O (Bytes)" 
COLUMN physical_io_blks        FORMAT     999,999,999  HEADING  "Physical I/O (Blks)"
COLUMN physical_io_size        FORMAT 999,999,999,999  HEADING  "Physical I/O (Bytes)"
COLUMN session_program         FORMAT a26        HEADING 'Session Program' TRUNC

SELECT
    s.inst_id,s.sid                                     sid
  , lpad(s.status,9)                          session_status
  , lpad(s.username,14)                       oracle_username
  , lpad(TO_CHAR(TO_DATE(b.start_time,'mm/dd/yy hh24:mi:ss')
           ,'mm/dd/yy hh24:mi:ss'
        )
       , 18
    )  trnx_start_time
  , ROUND(60*24*(sysdate-to_date(b.start_time,'mm/dd/yy hh24:mi:ss')),2)        elapsed_time
  , lpad(c.segment_name,9)                    undo_name
  , b.used_urec                               number_of_undo_records
  , b.used_ublk * d.value                     used_undo_size
  , b.log_io*d.value                          logical_io_size
  , b.phy_io*d.value                          physical_io_size
FROM
    gv$session         s
  , gv$transaction     b
  , dba_rollback_segs c
  , gv$parameter       d
  , gv$process         p
WHERE
      b.ses_addr = s.saddr
  AND b.xidusn   = c.segment_id
  AND d.name     = 'db_block_size'
  AND p.ADDR     = s.PADDR
ORDER BY 5 desc
/


COLUMN sid      clear             
COLUMN serial_id             clear
COLUMN session_status        clear
COLUMN oracle_username       clear
COLUMN os_username           clear
COLUMN os_pid                clear
COLUMN trnx_start_time       clear
COLUMN current_time          clear
COLUMN elapsed_time          clear
COLUMN undo_name             clear
COLUMN number_of_undo_records clear
COLUMN used_undo_blks        clear
COLUMN used_undo_size        clear
COLUMN logical_io_blks       clear
COLUMN logical_io_size       clear
COLUMN physical_io_blks      clear
COLUMN physical_io_size      clear
COLUMN session_program       clear

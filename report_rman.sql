/* Formatted on 2012-04-23 19:02:02 (QP5 v5.115.810.9015) */
  SELECT   DISTINCT bjd.db_name,
                    bjd.session_key,
                    bjd.db_name,
                    bsd.backup_type,
                    bjd.start_time,
                    bjd.STATUS,
                    bjd.time_taken_display,
                    bsd.incremental_level,
                    BJD.INPUT_BYTES_DISPLAY,
                    BJD.output_BYTES_DISPLAY,
                    BJD.COMMAND_ID
    FROM   rc_rman_backup_job_details bjd, rc_backup_set_details bsd
   WHERE   bsd.incremental_level IN (0, 1, 2)
           AND bjd.session_key = bsd.session_key
           and bjd.db_name='&BDHCA'
ORDER BY   bjd.start_time DESC;


  SELECT   DISTINCT bjd.db_name,
                    bjd.session_key,
                    DECODE (backup_type, 'L', 'Archive Log', 'D', 'Full', 'Incremental') BACKUP_TYPE,
                    bjd.start_time,
                    bjd.STATUS,
                    bjd.time_taken_display,
                    bsd.incremental_level,
                    BJD.INPUT_BYTES_DISPLAY,
                    BJD.output_BYTES_DISPLAY
    FROM   rc_rman_backup_job_details bjd, rc_backup_set_details bsd
   WHERE   bsd.incremental_level IN (0, 1, 2)
           AND bjd.session_key = bsd.session_key
           and bjd.db_name='BDHPT'
ORDER BY   bjd.start_time DESC;

SELECT SESSION_KEY, INPUT_TYPE, STATUS,
       TO_CHAR(START_TIME,'yyyy/mm/dd/ hh24:mi') start_time,
       TO_CHAR(END_TIME,'yyyy/mm/dd hh24:mi')   end_time,
       round(ELAPSED_SECONDS/3600,2)                   hrs,
       input_bytes_display, output_bytes_display, time_taken_display
FROM V$RMAN_BACKUP_JOB_DETAILS
ORDER BY SESSION_KEY;





--View BD:
  SELECT   DISTINCT-- bjd.db_name,
                    bjd.session_key,
                    DECODE (backup_type, 'L', 'Archive Log', 'D', 'Full', 'Incremental') BACKUP_TYPE,
                    bjd.start_time,
                    bjd.STATUS,
                    bjd.time_taken_display,
                    bsd.incremental_level,
                    BJD.INPUT_BYTES_DISPLAY,
                    BJD.output_BYTES_DISPLAY
    FROM   v$rman_backup_job_details bjd, v$backup_set_details bsd
   WHERE   bsd.incremental_level IN (0, 1, 2)
           AND bjd.session_key = bsd.session_key
           --and bjd.db_name='BDHPT'
ORDER BY   bjd.start_time DESC;



--View all BD RMAN:

SELECT DISTINCT (bjd.session_key), --backup full + incr
  DECODE (backup_type, 'L', 'Archive Log', 'D', 'Full', 'Incremental') BACKUP_TYPE,
  bjd.start_time,
  bjd.STATUS,
  bjd.time_taken_display,
  bsd.incremental_level,
  BJD.INPUT_BYTES_DISPLAY,
  BJD.output_BYTES_DISPLAY
FROM v$rman_backup_job_details bjd,
  v$backup_set_details bsd
WHERE bsd.incremental_level IN (0, 1, 2)
AND bjd.session_key          = bsd.session_key
UNION
SELECT DISTINCT (bjd.session_key), --backup archives isolados
  DECODE (backup_type, 'L', 'Archive Log', 'D', 'Full', 'Incremental') BACKUP_TYPE,
  bjd.start_time,
  bjd.STATUS,
  bjd.time_taken_display,
  bsd.incremental_level,
  BJD.INPUT_BYTES_DISPLAY,
  BJD.output_BYTES_DISPLAY
FROM v$rman_backup_job_details bjd,
  v$backup_set_details bsd
WHERE bjd.input_type LIKE 'ARC%'
AND backup_type     ='L'
AND bjd.session_key = bsd.session_key
ORDER BY start_time DESC;






--Catálogo RMAN:
--Report backups ultimo dia
alter session set current_schema=RC_PRD11;

SELECT DISTINCT bd.name,
  BJD.SESSION_KEY,
  DECODE (BACKUP_TYPE, 'L', 'Archive Log', 'D', 'Full', 'Incremental') BACKUP_TYPE,
  TO_CHAR(bjd.start_time,'YYYY/MM/DD HH24:MI:SS') start_time,
  bjd.STATUS,
  bjd.time_taken_display,
  bsd.incremental_level,
  BJD.INPUT_BYTES_DISPLAY,
  BJD.OUTPUT_BYTES_DISPLAY
FROM RC_DATABASE BD,
  RC_RMAN_BACKUP_JOB_DETAILS BJD,
  RC_BACKUP_SET_DETAILS BSD
WHERE BSD.INCREMENTAL_LEVEL IN (0, 1, 2)
AND BJD.DB_KEY            = BD.DB_KEY
AND BJD.SESSION_KEY          = BSD.SESSION_KEY
AND BSD.DB_KEY            = BD.DB_KEY
AND BJD.START_TIME        > SYSDATE -1
ORDER BY 1;



--Report max backup para BDs sem backup no ultimo dia
SELECT DISTINCT bd.name,
  BJD.SESSION_KEY,
  DECODE (BACKUP_TYPE, 'L', 'Archive Log', 'D', 'Full', 'Incremental') BACKUP_TYPE,
  TO_CHAR(bjd.start_time,'YYYY/MM/DD HH24:MI:SS') start_time,
  bjd.STATUS,
  bjd.time_taken_display,
  bsd.incremental_level,
  BJD.INPUT_BYTES_DISPLAY,
  BJD.OUTPUT_BYTES_DISPLAY
FROM RC_DATABASE BD,
  RC_RMAN_BACKUP_JOB_DETAILS BJD,
  RC_BACKUP_SET_DETAILS BSD
WHERE BSD.INCREMENTAL_LEVEL IN (0, 1, 2)
AND BJD.DB_KEY               = BD.DB_KEY
AND BJD.SESSION_KEY          = BSD.SESSION_KEY
AND BSD.DB_KEY               = BD.DB_KEY
AND NOT EXISTS
  (SELECT 1
  FROM RC_RMAN_BACKUP_JOB_DETAILS BJD2
  WHERE BJD2.DB_KEY   =BD.DB_KEY
  AND BJD2.START_TIME > SYSDATE -1
  )
AND BJD.START_TIME IN
  (SELECT MAX(START_TIME)
  FROM RC_RMAN_BACKUP_JOB_DETAILS A1
  WHERE a1.db_key=bjd.db_key
  )
ORDER BY 4;
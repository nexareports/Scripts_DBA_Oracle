--from sql:
SELECT SQL_ID,
  SQL_FULLTEXT,
  PLAN_HASH_VALUE,
  (ELAPSED_TIME/1000000)/EXECUTIONS AVG_ELAP,
  --PARSING_SCHEMA_NAME,
  ELAPSED_TIME/1000000,
  CPU_TIME/1000000,
  EXECUTIONS,
  MODULE
FROM V$SQL
where UPPER(PARSING_SCHEMA_NAME) like '%AGP%'
  --AND ELAPSED_TIME >= 1
  and EXECUTIONS>0
and ((ELAPSED_TIME/1000000)/EXECUTIONS) > 0.3
ORDER BY AVG_ELAP DESC
;



SELECT 
  STAT.SQL_ID,
  SQL_TEXT,
  PLAN_HASH_VALUE,
  PARSING_SCHEMA_NAME,
  ELAPSED_TIME_DELTA,
  STAT.SNAP_ID,
  SS.END_INTERVAL_TIME,
  EXECUTIONS_DELTA,
  MODULE
FROM
  DBA_HIST_SQLSTAT STAT,
  DBA_HIST_SQLTEXT TXT,
  DBA_HIST_SNAPSHOT SS
WHERE
  STAT.SQL_ID                  = TXT.SQL_ID
AND STAT.DBID                  = TXT.DBID
AND SS.DBID                    = STAT.DBID
AND SS.INSTANCE_NUMBER         = STAT.INSTANCE_NUMBER
AND STAT.SNAP_ID               = SS.SNAP_ID
--AND STAT.DBID                  = ?
--AND STAT.INSTANCE_NUMBER       = ?
AND SS.BEGIN_INTERVAL_TIME    >= sysdate-1
AND UPPER(PARSING_SCHEMA_NAME) not in ('SYSTEM','SYS','DBSNMP','ORACLE_OCM','EXFSYS')
AND MODULE                    IS NOT NULL
ORDER BY
  ELAPSED_TIME_DELTA DESC;


--por parsing_schema
SELECT
  dba_hist_sqltext.sql_id,
  module,
  --||':'||
  SUM(elapsed_time_delta)/1000000 elap_time,
  SUM(CPU_TIME_DELTA)/1000000 CPU_TIME,
  SUM(executions_delta) execs,
  SUM(elapsed_time_delta)/SUM(executions_delta)/1000000 AVG_Elap,
  -- dba_hist_sqlstat.executions_total
  dbms_lob.substr(dba_hist_sqltext.sql_text,3500,1) sql_id_text
FROM
  dba_hist_snapshot,
  dba_hist_sqlstat,
  dba_hist_sqltext
WHERE
  dba_hist_snapshot.snap_id=dba_hist_sqlstat.snap_id
AND dba_hist_sqlstat.sql_id=dba_hist_sqltext.sql_id
  --and sysdate-1/24 between dba_hist_snapshot.begin_interval_time and
  -- dba_hist_snapshot.end_interval_time
AND parsing_schema_name='BINFOLIO'
GROUP BY
  dba_hist_sqltext.sql_id,
  module,
  dbms_lob.substr(dba_hist_sqltext.sql_text,3500,1)
ORDER BY
  elap_time DESC;

  
-- Por user com sample size
select a.SAMPLE_TIME,   
       a.SQL_OPNAME,   
       a.SQL_EXEC_START,   
       a.program,   
       a.client_id,   
       b.SQL_TEXT,   
  (case when c.executions_delta > 0 then c.elapsed_time_delta/ c.executions_delta/ 1000000 else 0 end) seconds_per_exe,  
 e.username  
  from DBA_HIST_ACTIVE_SESS_HISTORY a  
      join dba_hist_sqltext b on (a.SQL_ID = b.SQL_ID)  
 join dba_users e on (a.user_id = e.user_id)  
       left outer join dba_hist_sqlstat c on (a.sql_id = c.sql_id)  
       left outer join dba_hist_snapshot d on (c.snap_id = d.snap_id and   
                                                               c.dbid = d.dbid and   
                                                               c.instance_number = d.instance_number and  
 a.sample_time between d.begin_interval_time and d.end_interval_time)  
 where username='JLB';
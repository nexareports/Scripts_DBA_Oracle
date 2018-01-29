--Agrupado por dia:
  SELECT   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD'),
           sum(ELAPSED_TIME_DELTA) elapse,
           sum(EXECUTIONS_DELTA)  execs,
           --count(*),
           ROUND (AVG (ELAPSED_TIME_DELTA / EXECUTIONS_DELTA) / 1000000, 3)
              avg_elapsed
    FROM   dba_hist_sqlstat sql, dba_hist_snapshot snap
   WHERE       sql.sql_id = '&sql_id'
           --and sql.dbid=&dbid
           AND sql.dbid = snap.dbid
           AND snap.snap_id = sql.snap_id
           AND SQL.INSTANCE_NUMBER = SNAP.INSTANCE_NUMBER
GROUP BY   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD')
ORDER BY  1-- snap.begin_interval_time desc;


--Agrupado por hora:
  SELECT   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD HH24'),
           sum(ELAPSED_TIME_DELTA) elapse,
           sum(EXECUTIONS_DELTA)  execs,
           --count(*),
           ROUND (AVG (ELAPSED_TIME_DELTA / EXECUTIONS_DELTA) / 1000000, 3)
              avg_elapsed
    FROM   dba_hist_sqlstat sql, dba_hist_snapshot snap
   WHERE       sql.sql_id = '&sql_id'
           --and sql.dbid=&dbid
           AND sql.dbid = snap.dbid
           AND snap.snap_id = sql.snap_id
           AND SQL.INSTANCE_NUMBER = SNAP.INSTANCE_NUMBER
GROUP BY   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD HH24')
ORDER BY  1-- snap.begin_interval_time desc;





--Acumlados diários superiores a 0 execuções:
  SELECT   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD'),
           sum(ELAPSED_TIME_DELTA) elapse,
           sum(EXECUTIONS_DELTA)  execs
    FROM   dba_hist_sqlstat sql, dba_hist_snapshot snap
   WHERE       sql.sql_id = '5b5b5vg4yn7dn'
           --and sql.dbid=&dbid
           AND sql.dbid = snap.dbid
           AND snap.snap_id = sql.snap_id
           AND SQL.INSTANCE_NUMBER = SNAP.INSTANCE_NUMBER
GROUP BY   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD')
ORDER BY  1;


-- Todos os planos de execução de um sqlid
select * from TABLE(DBMS_XPLAN.DISPLAY_AWR('&sqlid'));


--Validação de tempos de execução diários por sqlid e plano:
  SELECT   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD'),
           sql_id, 
           PLAN_HASH_VALUE,
           sum(ELAPSED_TIME_DELTA) elapse,
           sum(EXECUTIONS_DELTA)  execs
    FROM   dba_hist_sqlstat sql, dba_hist_snapshot snap
   WHERE       sql.sql_id = '5b5b5vg4yn7dn'
           --and sql.dbid=&dbid
           AND sql.dbid = snap.dbid
           --and PLAN_HASH_VALUE=3154157126
           AND snap.snap_id = sql.snap_id
           AND SQL.INSTANCE_NUMBER = SNAP.INSTANCE_NUMBER
GROUP BY   TO_CHAR (snap.begin_interval_time, 'YYYY/MM/DD'), sql_id, PLAN_HASH_VALUE
ORDER BY  1;
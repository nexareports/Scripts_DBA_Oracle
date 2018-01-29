set pages 2000
set feedback off
set markup html on preformat off
alter session set nls_date_format = 'dd-mm-yyyy hh24:mi:ss';
spool audit.html
--
prompt ##### 01 - Caracterizacao #####
prompt
--
select 'SID: '||instance_name as "Dados Instancia" from v$instance
union all
select '' from dual
union all
select 'Data: '||to_char(sysdate,'DD/MM/YYYY HH24:MI:SS') from dual
union all
select '' from dual
union all
select 'Versoes:' from dual
union all
select * from v$version
union all
select '' from dual
union all
select 'Disponibilidade:' from dual
union all
select 'Instancia em cima ha '||round((SYSDATE-logon_time)*24)||' Horas, aproximadamente '||trunc(SYSDATE-logon_time)||' dia(s)'
from   sys.v_$session
where  program like '%PMON%'
/
--
prompt
--
col force_log format a9
select DB_UNIQUE_NAME as uname, created, CONTROLFILE_TYPE, LOG_MODE, OPEN_MODE, DATABASE_ROLE as db_role, LAST_OPEN_INCARNATION# as Incarnation, FLASHBACK_ON as fback_on, FORCE_LOGGING as force_log from v$database
/
--
prompt
--
set heading off
select 'Opcao:', 'Activada:' from dual
union all
select '', '' from dual
union all
select * from v$option
/
set heading on
--
prompt
--
set heading off
select 'Funcionalidades em utilizacao' from dual;
set heading on
select name, version, detected_usages, first_usage_date, currently_used
from dba_feature_usage_statistics
where first_usage_date is not null
order by 1,2;
--
prompt
--
set heading off
select 'Recyclebin usage' from dual;
set heading on
select name, value, description from v$parameter where name = 'recyclebin';
--
prompt
--
set heading off
select 'Recyclebin objectos por user' from dual;
set heading on
select count(*) as "NUM_OBJ", owner, 
(sum(space))*(select value from v$parameter where name = 'db_block_size')/1024/1024 as "Mb Ocupados" 
from dba_recyclebin group by owner order by 1 desc;
--
prompt
set heading off
select 'BD e OS Blocksize' from dual;
set heading on
select name, value, description from v$parameter where name = 'db_block_size';
select max(lebsz) as "OS Block (Bytes)" from x$kccle;
prompt
prompt ##### 02 - Estrutura #####
prompt
--
set heading off
select 'Alocacao de espaco' from dual;
set heading on
SELECT sum(b.size_mb) "TOTAL MB",
       sum(b.size_mb)-sum(a.free_mb) "OCUPADO MB",
       sum(a.free_mb) "LIVRE MB"
FROM   (SELECT tablespace_name,
               Trunc(Sum(bytes)/1024/1024) free_mb
        FROM   dba_free_space
        GROUP BY tablespace_name) a,
       (SELECT tablespace_name,
               Trunc(Sum(bytes)/1024/1024) size_mb
        FROM   dba_data_files
        GROUP BY tablespace_name) b
WHERE  a.tablespace_name = b.tablespace_name
order by 2 desc;

prompt
--
set heading off
select 'Ficheiros da BD' from dual;
set heading on
--
Select Tipo,Size_in_MB,Ficheiro from (
select  'Datafile'	Tipo,
	file_name	Ficheiro,
	bytes/1024/1024 Size_in_MB
from 	dba_data_files
union all
select  'Tempfile'	Tipo,
	file_name	Ficheiro,
	bytes/1024/1024 Size_in_MB
from 	dba_temp_files
union all
select  'Controlfile'	Tipo,
	name		Ficheiro,
	15		Size_in_MB
from	v$controlfile
union all
select  'Redolog'	Tipo,
	a.member		Ficheiro,
	b.bytes/1024/1024	Size_in_MB
from	v$logfile a,v$log b where a.group#=b.group#)
order by 1,3,2 desc;
--
prompt
col id format 9999
select file_id as id, file_name, tablespace_name, status, autoextensible, online_status from dba_data_files order by file_id;

prompt
--
set heading off
select 'Dados de Tablespaces' from dual;
set heading on
SELECT /* + RULE */  df.tablespace_name "Tablespace",
       df.bytes / (1024 * 1024) "Size (MB)",
       SUM(fs.bytes) / (1024 * 1024) "Free (MB)",
       Nvl(Round(SUM(fs.bytes) * 100 / df.bytes),1) "% Free",
       Round((df.bytes - SUM(fs.bytes)) * 100 / df.bytes) "% Used"
  FROM dba_free_space fs,
       (SELECT tablespace_name,SUM(bytes) bytes
          FROM dba_data_files
         GROUP BY tablespace_name) df
 WHERE fs.tablespace_name (+)  = df.tablespace_name
 GROUP BY df.tablespace_name,df.bytes
UNION ALL
SELECT /* + RULE */ df.tablespace_name tspace,
       fs.bytes / (1024 * 1024),
       SUM(df.bytes_free) / (1024 * 1024),
       Nvl(Round((SUM(fs.bytes) - df.bytes_used) * 100 / fs.bytes), 1),
       Round((SUM(fs.bytes) - df.bytes_free) * 100 / fs.bytes)
  FROM dba_temp_files fs,
       (SELECT tablespace_name,bytes_free,bytes_used
          FROM v$temp_space_header
         GROUP BY tablespace_name,bytes_free,bytes_used) df
 WHERE fs.tablespace_name (+)  = df.tablespace_name
 GROUP BY df.tablespace_name,fs.bytes,df.bytes_free,df.bytes_used
 ORDER BY 5 DESC;

prompt
--
set heading off
select 'Estruturas de memoria (SGASTAT)' from dual;
set heading on
SELECT 'DB Buffer Cache' area, name, trunc(sum(bytes)/1024/1024,2) "Size"
FROM v$sgastat
WHERE pool is null and
--name = 'db_block_buffers'
name = 'buffer_cache'
group by name
union all
SELECT 'Shared Pool', pool, trunc(sum(bytes)/1024/1024,2) "Size"
FROM v$sgastat
WHERE pool = 'shared pool'
group by pool
union all
SELECT 'Large Pool', pool, trunc(sum(bytes)/1024/1024,2) "Size"
FROM v$sgastat
WHERE pool = 'large pool'
group by pool
union all
SELECT 'Java Pool', pool, trunc(sum(bytes)/1024/1024,2) "Size"
FROM v$sgastat
WHERE pool = 'java pool'
group by pool
union all
SELECT 'Redo Log Buffer', name, trunc(sum(bytes)/1024/1024,2) "Size"
FROM v$sgastat
WHERE pool is null and
name = 'log_buffer'
group by name
union all
SELECT 'Fixed SGA', name, trunc(sum(bytes)/1024/1024,2) "Size"
FROM v$sgastat
WHERE pool is null and
name = 'fixed_sga'
group by name
ORDER BY 3 desc;

prompt
--
set heading off
select 'Retencao de AWR' from dual;
set heading on
select * from DBA_HIST_WR_CONTROL;

prompt
--
set heading off
select 'Retencao de estatisticas' from dual;
set heading on
select dbms_stats.get_stats_history_retention from dual;

prompt
--
set heading off
select 'Parametrizacoes' from dual;
set heading on
select name, value, description from v$parameter;

prompt
--
prompt ##### 03 - Seguranca #####
prompt
--
set heading off
select 'Privilegios SYSDBA' from dual;
set heading on
select * from sys.v_$pwfile_users;
--
prompt
--
set heading off
select 'Parametros obsoletos' from dual;
set heading on
select * from V$OBSOLETE_PARAMETER where isspecified = 'TRUE';
--
prompt
--
set heading off
select 'Parametros not default' from dual;
set heading on
SELECT p.name,
       i.instance_name AS sid,
       p.value AS current_value,
       sp.sid,
       sp.value AS spfile_value      
FROM   v$spparameter sp,
       v$parameter p,
       v$instance i
WHERE  sp.name   = p.name
AND    sp.value != p.value;
--
prompt
set heading off
select 'Database Triggers' from dual;
set heading on
select owner,trigger_name,BASE_OBJECT_TYPE from dba_triggers where BASE_OBJECT_TYPE like '%DATABASE%';
--
prompt
set heading off
select 'Privilegios de Audit' from dual;
set heading on
select grantee,privilege,admin_option
from dba_sys_privs
where privilege like '%AUDIT%';
prompt
set heading off
select 'Roles criticas' from dual;
set heading on
select grantee, granted_role, admin_option
from   sys.dba_role_privs 
where  granted_role in ('DBA', 'AQ_ADMINISTRATOR_ROLE',
                       'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE',
                       'OEM_MONITOR')
  and  grantee not in ('SYS', 'SYSTEM', 'OUTLN', 'AQ_ADMINISTRATOR_ROLE',
                       'DBA', 'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE',
                       'OEM_MONITOR', 'CTXSYS', 'DBSNMP', 'IFSSYS',
                       'IFSSYS$CM', 'MDSYS', 'ORDPLUGINS', 'ORDSYS',
                       'TIMESERIES_DBA');

prompt
set heading off
select 'Ultimos backups RMAN (8 dias)' from dual;
set heading on
SELECT
    bs.recid                                              bs_key
  , DECODE(backup_type
           , 'L', 'Archived Logs'
           , 'D', 'Datafile Full'
           , 'I', 'Incremental')                          backup_type
  , device_type                                           device_type
  , DECODE(   bs.controlfile_included
            , 'NO', null
            , bs.controlfile_included)                    controlfile_included
  , sp.spfile_included                                    spfile_included
  , bs.incremental_level                                  incremental_level
  , bs.pieces                                             pieces
  , TO_CHAR(bs.start_time, 'dd-mm-yyyy HH24:MI:SS')         start_time
  , TO_CHAR(bs.completion_time, 'dd-mm-yyyy HH24:MI:SS')    completion_time
  , trunc(bs.elapsed_seconds,2)                                    elapsed_seconds
  , bp.tag                                                tag
  , bs.block_size                                         block_size
FROM
    v$backup_set                           bs
  , (select distinct
         set_stamp
       , set_count
       , tag
       , device_type
     from v$backup_piece
     where status in ('A', 'X'))           bp
 ,  (select distinct
         set_stamp
       , set_count
       , 'YES'     spfile_included
     from v$backup_spfile)                 sp
WHERE
      bs.set_stamp = bp.set_stamp
  AND bs.set_count = bp.set_count
  AND bs.set_stamp = sp.set_stamp (+)
  AND bs.set_count = sp.set_count (+)
-- para os ultimos 8 dias somente descomentar linha abaixo
  AND trunc(bs.start_time) > trunc(sysdate-8)
ORDER BY
    bs.recid desc, bs.start_time;

prompt
set heading off
select 'Listagem de DB Links' from dual;
set heading on
select * from dba_db_links;

prompt
prompt ##### 04 - Eficiencia #####
prompt
set heading off
select 'Hit Ratios' from dual;
set heading on
SELECT 'Dictionary Cache Hit Ratio' as Ratio, 
  LPad(To_Char(Round((1 - (Sum(getmisses)/(Sum(gets) + Sum(getmisses)))) * 100,2),'990.00') || '%',8,' ') as Percentagem,
  'Deve ser acima de 90% - Caso nao seja, aumentar SHARED_POOL_SIZE' as Recomendacao
  FROM   v$rowcache
union all
  SELECT 'Library Cache Hit Ratio',
  LPad(To_Char(Round((1 -(Sum(reloads)/(Sum(pins) + Sum(reloads)))) * 100,2),'990.00') || '%',8,' '),
  'Deve ser acima de 99% - Caso nao seja, aumentar SHARED_POOL_SIZE'
  FROM   v$librarycache
union all
  SELECT 'DB Block Buffer Cache Hit Ratio',
  LPad(To_Char(Round((1 - (phys.value / (db.value + cons.value))) * 100,2),'990.00') || '%',8,' '),
  'Deve ser acima de 89% - Caso nao seja, aumentar DB_BLOCK_BUFFERS'
  FROM   v$sysstat phys,
         v$sysstat db,
         v$sysstat cons
  WHERE  phys.name  = 'physical reads'
  AND    db.name    = 'db block gets'
  AND    cons.name  = 'consistent gets'
union all  
  SELECT 'Latch Hit Ratio',
  LPad(To_Char(Round((1 - (Sum(misses) / Sum(gets))) * 100,2),'990.00') || '%',8,' '),
  'Deve ser acima de 98% - Caso nao seja, aumentar numero de latches'
  FROM   v$latch
union all
  SELECT 'Disk Sort Ratio',
  LPad(To_Char(Round((disk.value/mem.value) * 100,2),'990.00') || '%',8,' '),
  'Deve ser abaixo de 5% - Caso nao seja, aumentar SORT_AREA_SIZE'
  FROM   v$sysstat disk,
         v$sysstat mem
  WHERE  disk.name = 'sorts (disk)'
  AND    mem.name  = 'sorts (memory)'
union all
  SELECT 'Rollback Segment Waits',
  LPad(To_Char(Round((Sum(waits) / Sum(gets)) * 100,2),'990.00') || '%',8,' '),
  'Deve ser abaixo de 5% - Caso nao seja, aumentar numero de Rollback Segments'
  FROM   v$rollstat
union all
  SELECT 'Dispatcher Workload',
  LPad(To_Char(Round(NVL((Sum(busy) / (Sum(busy) + Sum(idle))) * 100,0),2),'990.00') || '%',8,' '),
  'Deve ser abaixo de 50% - Caso nao seja, aumentar MTS_DISPATCHERS'
  FROM   v$dispatcher;
--
prompt
set heading off
select 'Buffer Pools Hit Ratios' from dual;
set heading on
SELECT a.name "Pool", a.physical_reads, a.db_block_gets
      , a.consistent_gets
,(SELECT ROUND(
(1-(physical_reads/(db_block_gets + consistent_gets)))*100)||'%'
      FROM v$buffer_pool_statistics
      WHERE db_block_gets+consistent_gets ! = 0
      AND name = a.name) "Ratio"
FROM v$buffer_pool_statistics a;
--
prompt
set heading off
select 'Table access efficiency' from dual;
set heading on
SELECT 'Short to Long Full Table Scans' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
WHERE name = 'table scans (short tables)')
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name IN
   ('table scans (short tables)', 'table scans (long 
      tables)'))
* 100, 2)||'%' "Percentage"
FROM DUAL
UNION
SELECT 'Short Table Scans ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
WHERE name = 'table scans (short tables)')
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name IN
   ('table scans (short tables)', 'table scans (long
      tables)'
, 'table fetch by rowid'))
* 100, 2)||'%' "Percentage"
FROM DUAL
UNION
SELECT 'Long Table Scans ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
   WHERE name = 'table scans (long tables)')
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name
   IN ('table scans (short tables)', 'table scans (long 
      tables)', 'table fetch by rowid'))
* 100, 2)||'%' "Percentage"
FROM DUAL
UNION
SELECT 'Table by Index ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'table fetch
   by rowid')
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name
    IN ('table scans (short tables)', 'table scans (long 
      tables)', 'table fetch by rowid'))
* 100, 2)||'%' "Percentage"
FROM DUAL
UNION
SELECT 'Efficient Table Access ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT WHERE name
   IN ('table scans (short tables)','table fetch by rowid'))
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name
     IN ('table scans (short tables)', 'table scans (long 
      tables)', 'table fetch by rowid'))
* 100, 2)||'%' "Percentage"
FROM DUAL;
prompt
set heading off
select 'Index Usage' from dual;
set heading on
SELECT name, to_char(value) as value FROM V$SYSSTAT WHERE name IN
      ('table fetch by rowid', 'table scans
         (short tables)', 'table scans (long tables)')
OR name LIKE 'index fast full%' OR name = 'index fetch by key'
union all
select '', '' from dual
union all
SELECT 'Index to Table Ratio ' "Ratio" , ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
      WHERE name LIKE 'index fast full%'
      OR name = 'index fetch by key'
      OR name = 'table fetch by rowid')
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE
   name IN
      ('table scans (short tables)', 'table scans (long
         tables)')
),0)||':1' "Result"
FROM DUAL
/
prompt
set heading off
select 'Existencia de Chained Rows' from dual;
set heading on
SELECT 'Chained Rows ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
WHERE name = 'table fetch continued row')
/ (SELECT SUM(value) FROM V$SYSSTAT
   WHERE name IN ('table scan rows gotten', 'table fetch
      by rowid'))
* 100, 3)||'%' "Percentage"
FROM DUAL;
prompt
set heading off
select 'Tabelas com mais de 10% de Chained Rows' from dual;
set heading on
SELECT owner,
       table_name
       chain_cnt,
       round(chain_cnt/num_rows*100,2) pct_chained,
       avg_row_len, pct_free , pct_used
  FROM dba_tables
WHERE owner
                        not in ('SYS', 'SYSTEM', 'OUTLN', 'AQ_ADMINISTRATOR_ROLE',
                       'DBA', 'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE',
                       'OEM_MONITOR', 'CTXSYS', 'DBSNMP', 'IFSSYS',
                       'IFSSYS$CM', 'MDSYS', 'ORDPLUGINS', 'ORDSYS',
                       'TIMESERIES_DBA', 'TSMSYS', 'WMSYS')
and avg_row_len > 0
and round(chain_cnt/num_rows*100,2) > 10
order by 1,3 desc
/
prompt
set heading off
select 'Acesso a datafiles "buffer busy waits" > 100ms' from dual;
set heading on
SELECT
indx+1                         file#
, b.name                         filename
, count                          ct
, time                           "Time ms"
, time/(DECODE(count,0,1,count)) "Avg ms"
FROM
x$kcbfwait   a
, v$datafile   b
WHERE
indx < (select count(*) from v$datafile)
AND a.indx+1 = b.file#
and time/(DECODE(count,0,1,count)) > 100
order by 5 desc
/
prompt
set heading off
select 'Acesso a datafiles I/O' from dual;
set heading on
select fs.name     as "DataFile Name",
       f.phyblkrd  as "Physical Blk Read",
       f.phyblkwrt as "Physical Blks Wrtn",
       f.readtim   as "Read Time",
       f.writetim  as "Write Time",
       round (f.phyblkrd / f.readtim,2) ||'ms/read' as "Time by operation"
from   v$filestat f, v$datafile fs
where  f.file#  =  fs.file#
and f.readtim > 0
union all
select fs.name     as "DataFile Name",
       f.phyblkrd  as "Physical Blk Read",
       f.phyblkwrt as "Physical Blks Wrtn",
       f.readtim   as "Read Time",
       f.writetim  as "Write Time",
       round (f.phyblkwrt / f.writetim,2) ||'ms/write'
from   v$filestat f, v$datafile fs
where  f.file#  =  fs.file#
and f.writetim > 0
order  by 1
/
prompt
set heading off
select 'Rollback contention' from dual;
set heading on
select name, to_char(waits) as waits, gets
from   v$rollstat, v$rollname
where  v$rollstat.usn = v$rollname.usn
union all
select 'The average of waits/gets is ',
   round((sum(waits) / sum(gets)) * 100,2)||'%', null
From    v$rollstat;

select 'Total requests = '||sum(count) as contencoes
from    v$waitstat
union all
select '' from dual
union all
select 'Contention for system undo header = '||
       (round(count/((select sum(count) from v$waitstat)+0.00000000001),4)) * 100||'%'
from  v$waitstat
where   class = 'system undo header'
union all
select 'Contention for system undo block = '||
       (round(count/((select sum(count) from v$waitstat)+0.00000000001),4)) * 100||'%'
from    v$waitstat
where   class = 'system undo block'
union all
select 'Contention for undo header = '||
       (round(count/((select sum(count) from v$waitstat)+0.00000000001),4)) * 100||'%'
from    v$waitstat
where   class = 'undo header'
union all
select 'Contention for undo block = '||
       (round(count/((select sum(count) from v$waitstat)+0.00000000001),4)) * 100||'%'
from    v$waitstat
where   class = 'undo block'
union all
select 'If the percentage for an area is more than 1% or 2%, consider creating more rollback segments' from dual
union all
select '' from dual
union all
select name||' = '||value  
from   v$sysstat  
where  name = 'redo log space requests'
union all
select 'Should be near 0. If this condition exists over time, increase the size of LOG_BUFFER in increments of 5% until the value nears 0' from dual;

prompt
set heading off
select 'Top 10 non Idle Events' from dual;
set heading on
select EVENT, TOTAL_WAITS, TIME_WAITED, AVERAGE_WAIT, WAIT_CLASS from   v$system_event
where ROWNUM < 11
and WAIT_CLASS <> 'Idle'
order by time_waited desc, total_timeouts desc, total_waits desc
/

prompt
set heading off
select 'Wait statistics' from dual;
set heading on
select class,  count,  time, round(time/count,2) as "AVG ms"
from   v$waitstat
where  count > 0
order  by class
/

prompt
set heading off
select 'Sort Area Size' from dual;

select 'INIT.ORA ==> sort_area_size: '||value  
from    v$parameter  
where   name like 'sort_area_size';
set heading on
select a.name,  value  
from   v$statname a,  v$sysstat  
where  a.statistic#  =   v$sysstat.statistic#  
and    a.name        in ('sorts (disk)', 'sorts (memory)', 'sorts (rows)');

prompt
set heading off
select 'Statements running' from dual;
set heading on
select startup_time "Database Started Up In",
        sum(executions) "Total SQL run since startup",
             sum(users_executing) "SQL executing now"  
                from v$sqlarea, v$instance
                group by startup_time;

prompt
set heading off
select 'Indices Redundantes' from dual;
set heading on
select
  o1.name||'.'||n1.name  redundant_index,
  o2.name||'.'||n2.name  sufficient_index
from
  sys.icol$  ic1,
  sys.icol$  ic2,
  sys.ind$  i1,
  sys.obj$  n1,
  sys.obj$  n2,
  sys.user$  o1,
  sys.user$  o2
where
  ic1.pos# =1 and
  ic2.bo# =ic1.bo# and
  ic2.obj# !=ic1.obj# and
  ic2.pos# =1 and
  ic2.intcol# =ic1.intcol# and
  i1.obj# =ic1.obj# and
  bitand(i1.property, 1) =0 and
  ( select
      max(pos#) * (max(pos#) + 1) / 2
    from
      sys.icol$
    where
      obj# =ic1.obj#
  ) =
  ( select
      sum(xc1.pos#)
    from
      sys.icol$ xc1,
      sys.icol$ xc2
    where
      xc1.obj# =ic1.obj# and
      xc2.obj# =ic2.obj# and
      xc1.pos# =xc2.pos# and
      xc1.intcol# =xc2.intcol#
  ) and
  n1.obj# =ic1.obj# and
  n2.obj# =ic2.obj# and
  o1.user# =n1.owner# and
  o2.user# =n2.owner#
  and o1.name not in ('SYS', 'SYSTEM', 'SYSMAN', 'MDSYS', 'XDB');

prompt
set heading off
select 'SQL com geracao de IO intensivo' from dual;
set heading on
Select * from (
SELECT sql_id, hash_value, executions,
       round(disk_reads / executions, 2) reads_per_run,
       disk_reads, buffer_gets,
       round((buffer_gets - disk_reads) / buffer_gets, 2)*100 hit_ratio
FROM   v$sqlarea
WHERE  executions  > 0
AND    buffer_gets > 0
AND    (buffer_gets - disk_reads) / buffer_gets < 0.80
ORDER BY 4 desc) where rownum<11 order by 4 desc;

prompt
set heading off
select 'Objectos Invalidos' from dual;
set heading on
select owner, object_name, object_type, timestamp, status
from dba_objects where status <> 'VALID' and object_name not like 'BIN%'
order by owner, object_type;

prompt
set heading off
select 'Limites de parametros excedidos ou igualados em algum ponto no tempo' from dual;
set heading on
SELECT resource_name,current_utilization, max_utilization, initial_allocation, limit_value
  FROM v$resource_limit
WHERE max_utilization >= limit_value AND
         limit_value not like '%UNLIMITED%' 
         and trim(limit_value) != '0';

prompt
set heading off
select 'Ocupacao de tablespace SYSAUX de total (Mb):', (select sum(round(bytes/1024/1024,2)) from dba_data_files where tablespace_name='SYSAUX') from dual;
set heading on
SELECT occupant_name, round(space_usage_kbytes/1024,2) as "Espaco ocupado em MB" FROM V$SYSAUX_OCCUPANTS order by 2 desc;

prompt
set heading off
select 'Resize de componentes de memoria' from dual;
set heading on
select * from v$memory_resize_ops order by start_time, end_time;

prompt
set heading off
select 'Detalhe de areas de memoria' from dual;
set heading on
select * from v$memory_dynamic_components;

prompt
set heading off
select 'Eficiencia de PGA' from dual;
set heading on
select * from v$pgastat where name in
('cache hit percentage',
'aggregate PGA target parameter',
'aggregate PGA auto target',
'total PGA allocated',
'maximum PGA allocated',
'process count',
'max processes count');

prompt
set heading off
select 'Main Memory Advisors' from dual;
set heading on
prompt
set heading off
select 'PGA Target Advisor' from dual;
set heading on
select * from v$pga_target_advice;

prompt
set heading off
select 'SGA Target Advisor' from dual;
set heading on
select * from V$SGA_TARGET_ADVICE;

prompt
set heading off
select 'Shared Pool Advisor' from dual;
set heading on
select * from v$shared_pool_advice;

prompt
set heading off
select 'DB Buffer Caches Advisor' from dual;
set heading on
select * from V$DB_CACHE_ADVICE;

prompt
set heading off
select 'Java Pool Advisor' from dual;
set heading on
select * from v$java_pool_advice;

prompt
set heading off
select 'Streams Pool Advisor' from dual;
set heading on
select * from v$streams_pool_advice;

prompt
set heading off
select 'Utilizacao de Flash Recovery Area' from dual;
set heading on
select * from V$FLASH_RECOVERY_AREA_USAGE;

prompt
set heading off
select 'Crescimento de tablespaces (Requer licenca AWR)' from dual;
set heading on
SELECT TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY') days
, ts.tsname
, max(round((tsu.tablespace_size* dt.block_size )/(1024*1024),2) ) cur_size_MB
, max(round((tsu.tablespace_usedsize* dt.block_size )/(1024*1024),2)) usedsize_MB
, round((100 * (max(round((tsu.tablespace_usedsize* dt.block_size )/(1024*1024),2))))/(max(round((tsu.tablespace_size* dt.block_size )/(1024*1024),2))),0) percent_free
FROM DBA_HIST_TBSPC_SPACE_USAGE tsu
, DBA_HIST_TABLESPACE_STAT ts
, DBA_HIST_SNAPSHOT sp
, DBA_TABLESPACES dt
WHERE tsu.tablespace_id= ts.ts#
AND tsu.snap_id = sp.snap_id
AND ts.tsname = dt.tablespace_name
AND ts.tsname NOT IN ('SYSAUX','SYSTEM')
AND ts.tsname NOT LIKE ('UNDO%')
GROUP BY TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), ts.tsname
ORDER BY ts.tsname, days;

prompt
set heading off
select 'Archive Logs gerados por dia' from dual;
set heading on
SELECT A.*,
Round(A.Count#*B.AVG#/1024/1024) Daily_Avg_Mb
FROM
(
SELECT
To_Char(First_Time,'YYYY-MM-DD') DAY,
Count(1) Count#,
Min(RECID) Min#,
Max(RECID) Max#
FROM
v$log_history
GROUP
BY To_Char(First_Time,'YYYY-MM-DD')
ORDER
BY 1 DESC
) A,
(
SELECT
Avg(BYTES) AVG#,
Count(1) Count#,
Max(BYTES) Max_Bytes,
Min(BYTES) Min_Bytes
FROM
v$log
) B;

prompt
set heading off
select 'Average log switch por hora (ultimos 7 dias)' from dual;
set heading on
SELECT * FROM ( 
SELECT * FROM ( 
SELECT   TO_CHAR(FIRST_TIME, 'DD/MM') AS "DAY" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '00', 1, 0)), '99') "00:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '01', 1, 0)), '99') "01:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '02', 1, 0)), '99') "02:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '03', 1, 0)), '99') "03:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '04', 1, 0)), '99') "04:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '05', 1, 0)), '99') "05:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '06', 1, 0)), '99') "06:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '07', 1, 0)), '99') "07:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '08', 1, 0)), '99') "08:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '09', 1, 0)), '99') "09:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '10', 1, 0)), '99') "10:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '11', 1, 0)), '99') "11:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '12', 1, 0)), '99') "12:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '13', 1, 0)), '99') "13:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '14', 1, 0)), '99') "14:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '15', 1, 0)), '99') "15:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '16', 1, 0)), '99') "16:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '17', 1, 0)), '99') "17:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '18', 1, 0)), '99') "18:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '19', 1, 0)), '99') "19:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '20', 1, 0)), '99') "20:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '21', 1, 0)), '99') "21:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '22', 1, 0)), '99') "22:00" 
       , TO_NUMBER(SUM(DECODE(TO_CHAR(FIRST_TIME, 'HH24'), '23', 1, 0)), '99') "23:00" 
    FROM V$LOG_HISTORY 
    WHERE extract(year FROM FIRST_TIME) = extract(year FROM sysdate) 
GROUP BY TO_CHAR(FIRST_TIME, 'DD/MM') 
) ORDER BY TO_DATE(extract(year FROM sysdate) || DAY, 'YYYY DD/MM') DESC 
) WHERE ROWNUM < 8;

prompt
set heading off
select 'Ultimos 10 findings do ADDM' from dual;
set heading on
select a.task_id, b.execution_end, b.status, a.finding_id, a.type, a.impact_type, a.message, a.more_info 
from DBA_ADVISOR_FINDINGS a, DBA_ADVISOR_LOG b
where a.task_id = b.task_id
and a.task_id > (select max(task_id) from dba_advisor_findings)-11 
order by b.execution_end desc, finding_id;

prompt
set heading off
select '10 maiores segmentos por tablespace que sejam ocupem mais de 1000 blocos = '|| round((select to_number(value)*1000/1024/1024 from v$parameter where name = 'db_block_size'),0) ||' Mb' from dual;
set heading on
select * from
( select tablespace_name,owner,segment_name,segment_type,blocks,round(blocks*(select to_number(value) from v$parameter where name = 'db_block_size')/1024/1024,0) as "Size Mb",rank()
over (partition by tablespace_name order by blocks desc) RANK from dba_segments )
where tablespace_name in (select tablespace_name from dba_tablespaces where contents = 'PERMANENT')
and blocks > 1000 and rank <= 10;

prompt
set heading off
select 'Maiores objectos por owner e sua significancia no total ocupado pelo mesmo' from dual;
set heading on
select a.ow owner,min(a.seg) || decode(count(*),1,'(none)',2,' ',' +')
segment,
to_char(sum(a.segb)/decode(count(*),1,1,count(*)-1),'9,999,999,999')
" SEG BYTES",
to_char(sum(a.owb),'9,999,999,999,999') " OWNER BYTES",
to_char(sum(a.segb)/decode(count(*),1,1,count(*)-1)/decode(sum(a.owb),0,1,
sum(a.owb))*100,'990.99')
" PCT"
from (
select owner ow,segment_name seg,
sum(bytes) segb,000000000000 owb
from dba_segments d
where owner not in ('TSMSYS','DBSNMP','OUTLN')
group by owner,segment_name
having sum(bytes) = (
select max(sum(bytes))
from dba_segments c
where c.owner = d.owner
group by c.segment_name)
union all
select owner,'~',0,sum(bytes)
from dba_segments
where owner not in ('TSMSYS','DBSNMP','OUTLN')
group by owner) a
group by a.ow;

prompt
set heading off
select 'Existencia de objectos de outro owner no tablespace SYSTEM' from dual;
set heading on
col segment_name format a35
select   owner
,        segment_name
,        segment_type
,        tablespace_name
from     dba_segments
where    tablespace_name = 'SYSTEM'
and      owner not in  ('SYS', 'SYSTEM')
/

prompt
set heading off
select 'Procurar picos de carga nos ultimos 30 dias (Requer licenca AWR)' from dual;
set heading on
column sample_hour format a16
select
   to_char(round(sub1.sample_time, 'HH24'), 'YYYY-MM-DD HH24:MI') as sample_hour,
   round(avg(sub1.on_cpu),1) as cpu_avg,
   round(avg(sub1.waiting),1) as wait_avg,
   round(avg(sub1.active_sessions),1) as act_avg,
   round( (variance(sub1.active_sessions)/avg(sub1.active_sessions)),1) as act_var_mean
from
   ( -- sub1: one row per second, the resolution of SAMPLE_TIME
     select
        sample_id,
        sample_time,
        sum(decode(session_state, 'ON CPU', 1, 0))  as on_cpu,
        sum(decode(session_state, 'WAITING', 1, 0)) as waiting,
        count(*) as active_sessions
     from
        dba_hist_active_sess_history
     where
        sample_time > sysdate - (720/24)
     group by
        sample_id,
        sample_time
   ) sub1
group by
   round(sub1.sample_time, 'HH24')
order by
   round(sub1.sample_time, 'HH24');
prompt
select * from (
select begin_snap, end_snap, timestamp begin_timestamp, inst, a/1000000/60 DBtime from
(
select
 e.snap_id end_snap,
 lag(e.snap_id) over (order by e.snap_id) begin_snap,
 lag(s.end_interval_time) over (order by e.snap_id) timestamp,
 s.instance_number inst,
 e.value,
 nvl(value-lag(value) over (order by e.snap_id),0) a
from dba_hist_sys_time_model e, DBA_HIST_SNAPSHOT s
where s.snap_id = e.snap_id
 and e.instance_number = s.instance_number
 and to_char(e.instance_number) like to_char(e.instance_number)
 and stat_name             = 'DB time'
)
where begin_snap=end_snap-1
order by dbtime desc
)
where rownum < 31;

prompt
set heading off
select '30 queries mais pesadas dos ultimos 30 dias' from dual;
set heading on
select
   sub.sql_id,
   sub.seconds_since_date,
   sub.execs_since_date,
   sub.gets_since_date
from
   ( -- sub to sort before rownum
     select
        sql_id,
        round(sum(elapsed_time_delta)/1000000) as seconds_since_date,
        sum(executions_delta) as execs_since_date,
        sum(buffer_gets_delta) as gets_since_date
     from
        dba_hist_snapshot natural join dba_hist_sqlstat
     where
        begin_interval_time > sysdate - 30
     group by
        sql_id
     order by
        2 desc
   ) sub
where
   rownum < 31;



prompt
prompt ##### 05 - ASM #####
prompt

prompt
set heading off
select 'Diskgoups' from dual;
set heading on
COLUMN group_name             FORMAT a20           HEAD 'Disk Group|Name'
COLUMN sector_size            FORMAT 99,999        HEAD 'Sector|Size'
COLUMN block_size             FORMAT 99,999        HEAD 'Block|Size'
COLUMN allocation_unit_size   FORMAT 999,999,999   HEAD 'Allocation|Unit Size'
COLUMN state                  FORMAT a11           HEAD 'State'
COLUMN type                   FORMAT a6            HEAD 'Type'
COLUMN total_mb               FORMAT 999,999,999   HEAD 'Total Size (MB)'
COLUMN used_mb                FORMAT 999,999,999   HEAD 'Used Size (MB)'
COLUMN pct_used               FORMAT 999.99        HEAD 'Pct. Used'

break on report on disk_group_name skip 1

compute sum label "Grand Total: " of total_mb used_mb on report

SELECT
    name                                     group_name
  , sector_size                              sector_size
  , block_size                               block_size
  , allocation_unit_size                     allocation_unit_size
  , state                                    state
  , type                                     type
  , total_mb                                 total_mb
  , (total_mb - free_mb)                     used_mb
  , ROUND((1- (free_mb / total_mb))*100, 2)  pct_used
FROM
    v$asm_diskgroup
ORDER BY
    name
/

prompt
set heading off
select 'Disk Performance' from dual;
set heading on
COLUMN disk_group_name    FORMAT a20               HEAD 'Disk Group Name'
COLUMN disk_path          FORMAT a20               HEAD 'Disk Path'
COLUMN reads              FORMAT 999,999,999       HEAD 'Reads'
COLUMN writes             FORMAT 999,999,999       HEAD 'Writes'
COLUMN read_errs          FORMAT 999,999           HEAD 'Read|Errors'
COLUMN write_errs         FORMAT 999,999           HEAD 'Write|Errors'
COLUMN read_time          FORMAT 999,999,999       HEAD 'Read|Time'
COLUMN write_time         FORMAT 999,999,999       HEAD 'Write|Time'
COLUMN bytes_read         FORMAT 999,999,999,999   HEAD 'Bytes|Read'
COLUMN bytes_written      FORMAT 999,999,999,999   HEAD 'Bytes|Written'

break on report on disk_group_name skip 2

compute sum label ""              of reads writes read_errs write_errs read_time write_time bytes_read bytes_written on disk_group_name
compute sum label "Grand Total: " of reads writes read_errs write_errs read_time write_time bytes_read bytes_written on report

SELECT
    a.name                disk_group_name
  , b.path                disk_path
  , b.reads               reads
  , b.writes              writes
  , b.read_errs           read_errs 
  , b.write_errs          write_errs
  , b.read_time           read_time
  , b.write_time          write_time
  , b.bytes_read          bytes_read
  , b.bytes_written       bytes_written
FROM
    v$asm_diskgroup a JOIN v$asm_disk b USING (group_number)
ORDER BY
    a.name
/

prompt
prompt ##### 06 - RAC #####
prompt

spool off
set feedback on
exit
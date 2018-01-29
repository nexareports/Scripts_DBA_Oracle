spool health_check_db.log
set feedback off;
set pagesize 0;
set echo off;

Select (SELECT NAME FROM V$DATABASE) ||'_Oracle_Database_Health_Report: '||to_char(sysdate,'Mon dd yyyy hh24:mi:ss') "TIMESTAMP" from dual;
prompt**=====================================================================================================**
prompt**    **Database Current Status**         
prompt**=====================================================================================================**
set pagesize 50;
set line 300;
col HOST_NAME FORMAT a12;
col "HOST_ADDRESS" FORMAT a15;
col RESETLOGS_TIME FORMAT a12;
col "DB RAC?" FORMAT A8;
col days format 9999;

select name INSTANCE,HOST_NAME, UTL_INADDR.GET_HOST_ADDRESS "HOST_ADDRESS",
LOGINS, archiver,to_char(STARTUP_TIME,'DD-MON-YYYY HH24:MI:SS') "DB_UP_TIME", RESETLOGS_TIME "RESET_TIME", FLOOR(sysdate-startup_time) days, 
(select DECODE(vp1.value,'TRUE','Yes ('|| decode(vp1.value,'TRUE',' instances: '||vp2.value)||')','No')
from v$instance,
(select value from v$parameter 
 where name like 'cluster_database'
) vp1,
(select value from v$parameter 
 where name like 'cluster_database_instances'
) vp2) "DB RAC?"
 from v$database,gv$instance;
SELECT BANNER "VERSION" FROM V$VERSION;
col "Database Details" format a60;
SELECT
    1 sort1,' DBNAME:'||name ||chr(9)||'DBID:'||dbid ||chr(9)|| 'Created:'||to_char(created, 'dd/mm/yyyy hh24:mi:ss') ||chr(10)||
            ' Log mode:'||log_mode || decode (log_mode,'ARCHIVELOG','',' !!!') ||chr(9)||'Forcelogging:'||force_logging||chr(9)||'Open mode:'||open_mode||chr(10)||
     ' Remote archiving:'||remote_archive||chr(9)||'Database role:'||database_role "Database Details"
FROM v$database
UNION
SELECT 2 sort1,'Datafiles: '||trim(TO_CHAR(COUNT(*),'9,990'))||chr(9)||'Datafile size(Gb): '||trim(TO_CHAR(SUM(bytes)/1073741824, '9,990'))
FROM v$datafile
UNION
SELECT 3 sort1,'Tempfiles: '||trim(TO_CHAR(COUNT(*),'9,990'))||chr(9)||'Tempfile size(Gb): '||trim(TO_CHAR(SUM(bytes)/1073741824, '9,990'))
FROM v$tempfile
UNION
SELECT 4 sort1,'Segment size (Gb): '||trim(TO_CHAR(SUM(bytes)/1073741824, '9,990'))
FROM dba_segments
UNION
SELECT 5 sort1,'Tables/Indexes: '|| trim(TO_CHAR(SUM(DECODE(type#, 2, 1, 0)), '999,990'))||'/'|| trim(TO_CHAR(SUM(DECODE(type#, 1, 1, 0)), '999,990'))
FROM sys.obj$ 
WHERE owner# <> 0 
UNION
SELECT 6 sort1,'Total DB Users: '||trim( TO_CHAR(COUNT(*), '9,990'))
FROM  sys.user$ WHERE 
type# = 1
UNION
SELECT 7 sort1,'Online Sessions: '||trim( TO_CHAR(COUNT(*), '9,990'))
FROM  gv$session
WHERE type='USER'
UNION
SELECT 8 sort1,'Active Sessions: '||trim( TO_CHAR(COUNT(*), '9,990'))
FROM  gv$session
WHERE type='USER' and status = 'ACTIVE'
UNION
SELECT 9 sort1,'Session highwater: '|| trim(TO_CHAR(sessions_highwater, '9,990'))
FROM v$license
UNION
SELECT 10 sort1,'SGA (Mb):  '||trim(TO_CHAR(SUM(value)/1048576, '99,990.99'))
FROM v$sga;

prompt**====================================================================================================**
prompt**    **Database Parameters Details**         
prompt**====================================================================================================**
set pagesize 600;
set line 200;
column "database parameter" format a40;
column "VALUE" format a40;
select  name "Database Parameter",value from v$spparameter 
where isspecified='TRUE' and NAME != 'control_files';

SET FEEDBACK OFF;
set pagesize 600;
set line 200;
column "NLS_Parameter" format a40;
column "VALUE" format a40;
Select parameter "NLS_Parameter", value from nls_database_parameters;

prompt
prompt
prompt**===================================================================================================**
prompt**    **Tunning Database SGA/PGA**
prompt**===================================================================================================**
prompt
set pagesize 0;
SELECT 'SGA MAX Size in MB:   '|| trunc(SUM(VALUE)/1024/1024, 2) "SGA_MAX_MB" FROM V$SGA;

set pagesize 50;
set line 200;
column "SGA Pool"format a33;
col "m_bytes" format 999999.99;
select pool "SGA Pool", m_bytes from ( select  pool, to_char( trunc(sum(bytes)/1024/1024,2), '99999.99' ) as M_bytes
    from v$sgastat
    where pool is not null   group  by pool
    union
    select name as pool, to_char( trunc(bytes/1024/1024,3), '99999.99' ) as M_bytes
    from v$sgastat
    where pool is null  order     by 2 desc
    ) UNION ALL
    select    'TOTAL' as pool, to_char( trunc(sum(bytes)/1024/1024,3), '99999.99' ) from v$sgastat;

Select round(tot.bytes  /1024/1024 ,2)  sga_total, round(used.bytes /1024/1024 ,2)  used_mb, round(free.bytes /1024/1024 ,2)  free_mb
from (select sum(bytes) bytes  from v$sgastat where  name != 'free memory') used,    
(select sum(bytes) bytes from  v$sgastat  where  name = 'free memory') free, 
(select sum(bytes) bytes from v$sgastat) tot;

select pool,  round(sgasize/1024/1024,2) "SGA_TARGET",  
round(bytes/1024/1024,2) "FREE_MB", 
round(bytes/sgasize*100, 2) "%FREE"
from  (select sum(bytes) sgasize from sys.v_$sgastat) s, sys.v_$sgastat f
where  f.name = 'free memory';

prompt
prompt
prompt Tunning Shared Pool Size:
prompt*-----------------------------------------------------------------------**

col "Data Dict. Gets" heading Data_Dict.|Gets;
col "Data Dict. Cache Misses" heading Dict._Cache|Misses;
col "Data Dict Cache Hit Ratio" heading Dict._Cache|Hit_Ratio;
col "% Missed" heading Missed|%;
SELECT SUM(gets)   "Data Dict. Gets", SUM(getmisses)  "Data Dict. Cache Misses"
  , TRUNC((1-(sum(getmisses)/SUM(gets)))*100, 2) "Data Dict Cache Hit Ratio"
  , TRUNC(SUM(getmisses)*100/SUM(gets), 2)  "% Missed"
FROM  v$rowcache;

prompt
Prompt* The Dict. Cache Hit% shuold be > 90% and misses% should be < 15%. If not consider increase SHARED_POOL_SIZE.

col "Cache Misses" heading Cache|Misses;
col "Library Cache Hit Ratio" heading Lib._Cache|Hit_Ratio;
col "% Missed" heading Missed|%;
SELECT SUM(pins)     "Executions", SUM(reloads)  "Cache Misses"
  , TRUNC((1-(SUM(reloads)/SUM(pins)))*100, 2) "Library Cache Hit Ratio"
  , ROUND(SUM(reloads)*100/SUM(pins))       "% Missed"        
FROM  v$librarycache;
prompt
Prompt* The Lib. Cache Hit% shuold be > 90% and misses% should be < 1%. If not consider increase SHARED_POOL_SIZE.

set pagesize 25;
col "Tot SQL since startup" format a25;
col "SQL executing now" format a17;
SELECT  TO_CHAR(SUM(executions)) "Tot SQL since startup", TO_CHAR(SUM(users_executing)) "SQL executing now"
FROM  v$sqlarea;

prompt
set pagesize 0;
select 'Cursor_Space_for_Time:  '|| value "Cursor_Space_for_Time"
from v$parameter  where name = 'cursor_space_for_time';

set pagesize 25;
col "Namespace" heading name|space;
col "Hit Ratio" heading Hit|Ratio;
col "Pin Hit Ratio" heading Pin_Hit|Ratio;
col "Invalidations" heading invali|dations;

SELECT  namespace  "Namespace", TRUNC(gethitratio*100) "Hit Ratio", 
TRUNC(pinhitratio*100) "Pin Hit Ratio", reloads "Reloads", invalidations  "Invalidations"
FROM  v$librarycache;

prompt            
prompt* GETHITRATIO and PINHITRATIO should be more than 90%.
prompt* If RELOADS > 0 then'cursor_space_for_time' Parameter do not set to 'TRUE'
prompt* More of Invalid object in namespace will cause more reloads.

set line 200;
col "NAME" format a30;
col "VALUE" format a12;
select p.name "NAME", a.free_space, p.value "VALUE", trunc(a.free_space/p.value, 2) "FREE%", requests, request_misses req_misses
from v$parameter p, v$shared_pool_reserved a
where p.name = 'shared_pool_reserved_size';

prompt
Prompt* %FREE should be > 0.5, request_failures,request_misses=0 or near 0. If not consider increase SHARED_POOL_RESERVED_SIZE and SHARED_POOL_SIZE.

prompt
prompt
prompt Tunning Buffer Cache:
prompt -----------------------------------------------------------------------**

SELECT  TRUNC( ( 1 - ( SUM(decode(name,'physical reads',value,0)) / ( SUM(DECODE(name,'db block gets',value,0))  
+ (SUM(DECODE(name,'consistent gets',value,0))) )) ) * 100  ) "Buffer Hit Ratio"
FROM v$sysstat;
prompt
prompt* The Buffer Cache Hit% should be >90%. If not and the shared pool hit ratio is good consider increase DB_CACHE_SIZE.

set line 200;
col event format a20;
select event, total_waits, time_waited
  from  v$system_event
    where event in ('buffer busy waits');
select s.segment_name, s.segment_type, s.freelists, w.wait_time, w.seconds_in_wait, w.state
    from dba_segments s, v$session_wait w
    where  w.event = 'buffer busy waits'
    AND w.p1 = s.header_file  AND  w.p2 = s.header_block;

prompt
prompt* Check for waits to find a free buffer in the buffer cache and Check if the I/O system is slow.
prompt* Consider increase the size of the buffer cache if it is too small. Consider increase the number of DBWR process if the buffer cache is properly sized.

prompt
prompt
prompt Tunning Redolog Buffer:
prompt -----------------------------------------------------------------------**

col "redolog space request" heading redolog_space|request;
col "redolog space wait time" heading redolog_space|wait_time;
col "Redolog space ratio"  heading redolog_space|ratio;
Select e. value "redolog space request", s.value "redolog space wait time", Round(e.value/s.value,2) "Redolog space ratio" 
From v$sysstat s, v$sysstat e
Where s.name = 'redo log space requests'
and e.name = 'redo entries';

prompt
prompt * If the ratio of redolog space is less than 5000 then increase the size of redolog buffer until this ratio stop falling.
prompt * There should be no log buffer space waits. Consider making logfile bigger or move the logfile to faster disk.

col "redo_buff_alloc_retries" heading redo_buffer|alloc_retries;
col "redo_entries" heading redo|entries;
col "pct_buff_alloc_retries" heading pct_buffer|alloc_retries;
 select    v1.value as "redo_buff_alloc_retries", v2.value as "redo_entries",
        trunc(v1.value/v2.value,4) as "pct_buff_alloc_retries"
    from     v$sysstat v1, v$sysstat v2
    where    v1.name = 'redo buffer allocation retries'
    and    v2.name = 'redo entries';

column latch_name format a20
select name latch_name, gets, misses, immediate_gets "Immed Gets", immediate_misses "Immed Misses", trunc((misses/decode(gets,0,1,gets))*100,2) Ratio1,
       trunc(immediate_misses/decode(immediate_misses+  immediate_gets,0,1, immediate_misses+immediate_gets)*100,2) Ratio2
from v$latch
where name like 'redo%';
prompt
prompt All ratios should be <= 1% if not then decrease the value of log_small_entry_max_size in init.ora

col event format a30;
select * from v$system_event
where event like 'log%';
prompt
Prompt* If Avg_wait_time is minor ignore it otherwise check the log buffer size w.r.t transaction rate and memory size.


prompt
prompt
prompt Tunning PGA Aggregate Target:
prompt -----------------------------------------------------------------------**

set pagesize 600;
set line 200;
column PGA_Component format a40;
column value format 999999999999;
select name "PGA_Component", value from v$pgastat;

Select count(*) "Total No. of Process" from v$process;

set line 200;
column "PGA Target" format a40;
column VALUE_MB format 9999999999.99
SELECT NAME "PGA Target", VALUE/1024/1024 VALUE_MB
FROM   V$PGASTAT
WHERE NAME IN ('aggregate PGA target parameter',
'total PGA allocated',
'total PGA inuse')
union
SELECT NAME, VALUE
FROM   V$PGASTAT
WHERE NAME IN ('over allocation count');

set line 200;
column "PGA_Work_Pass" format a40;
column "PER" format 999;
select  name "PGA_Work_Pass", cnt, decode(total, 0, 0, round(cnt*100/total)) per
from (select name, value cnt, (sum(value) over()) total
from v$sysstat where name like 'workarea exec%'
);

prompt
Prompt* DBA Must increase PGA_AGG_TARGET when "Multipass" > 0 and Reduce when "Optimal" executions 100%.

prompt
prompt Tunning SORT Area Size:
prompt -----------------------------------------------------------------------**

col name format a20;
select name,  value from v$sysstat
where name like 'sorts%';

prompt
prompt
prompt**===================================================================================================**
prompt**   **Tablespace/CRD File Information**
prompt**===================================================================================================**
col "Database Size" format a15;
col "Free space" format a15;
select round(sum(used.bytes) / 1024 / 1024/1024 ) || ' GB' "Database Size",
round(free.p / 1024 / 1024/1024) || ' GB' "Free space"
from (select bytes from v$datafile
union all select bytes from v$tempfile
union all select bytes from v$log) used,
(select sum(bytes) as p from dba_free_space) free
group by free.p;


SELECT  a.tablespace_name tablespace_name,
       ROUND(a.bytes_alloc / 1024 / 1024, 2) megs_alloc,
--       ROUND(NVL(b.bytes_free, 0) / 1024 / 1024, 2) megs_free,
       ROUND((a.bytes_alloc - NVL(b.bytes_free, 0)) / 1024 / 1024, 2) megs_used,
       ROUND((NVL(b.bytes_free, 0) / a.bytes_alloc) * 100,2) Pct_Free,
       (case when ROUND((NVL(b.bytes_free, 0) / a.bytes_alloc) * 100,2)<=0 
                                                then 'Immediate action required!'
             when ROUND((NVL(b.bytes_free, 0) / a.bytes_alloc) * 100,2)<5  
                                                then 'Critical (<5% free)'
             when ROUND((NVL(b.bytes_free, 0) / a.bytes_alloc) * 100,2)<15 
                                                then 'Warning (<15% free)'
             when ROUND((NVL(b.bytes_free, 0) / a.bytes_alloc) * 100,2)<25 
                                                then 'Warning (<25% free)'
             when ROUND((NVL(b.bytes_free, 0) / a.bytes_alloc) * 100,2)>60 
                                                then 'Waste of space? (>60% free)'
             else 'OK'
             end) msg
FROM  ( SELECT  f.tablespace_name,
               SUM(f.bytes) bytes_alloc,
               SUM(DECODE(f.autoextensible, 'YES',f.maxbytes,'NO', f.bytes)) maxbytes
        FROM DBA_DATA_FILES f
        GROUP BY tablespace_name) a,
      ( SELECT  f.tablespace_name,
               SUM(f.bytes)  bytes_free
        FROM DBA_FREE_SPACE f
        GROUP BY tablespace_name) b
WHERE a.tablespace_name = b.tablespace_name (+)
UNION
SELECT h.tablespace_name,
       ROUND(SUM(h.bytes_free + h.bytes_used) / 1048576, 2),
--       ROUND(SUM((h.bytes_free + h.bytes_used) - NVL(p.bytes_used, 0)) / 1048576, 2),
       ROUND(SUM(NVL(p.bytes_used, 0))/ 1048576, 2),
       ROUND((SUM((h.bytes_free + h.bytes_used) - NVL(p.bytes_used, 0)) / SUM(h.bytes_used + h.bytes_free)) * 100,2),
      (case when ROUND((SUM((h.bytes_free + h.bytes_used) - NVL(p.bytes_used, 0)) / SUM(h.bytes_used + h.bytes_free)) * 100,2)<=0 then 'Immediate action required!'
            when ROUND((SUM((h.bytes_free + h.bytes_used) - NVL(p.bytes_used, 0)) / SUM(h.bytes_used + h.bytes_free)) * 100,2)<5  then 'Critical (<5% free)'
            when ROUND((SUM((h.bytes_free + h.bytes_used) - NVL(p.bytes_used, 0)) / SUM(h.bytes_used + h.bytes_free)) * 100,2)<15 then 'Warning (<15% free)'
            when ROUND((SUM((h.bytes_free + h.bytes_used) - NVL(p.bytes_used, 0)) / SUM(h.bytes_used + h.bytes_free)) * 100,2)<25 then 'Warning (<25% free)'
            when ROUND((SUM((h.bytes_free + h.bytes_used) - NVL(p.bytes_used, 0)) / SUM(h.bytes_used + h.bytes_free)) * 100,2)>60 then 'Waste of space? (>60% free)'
            else 'OK'
            end) msg
FROM   sys.V_$TEMP_SPACE_HEADER h, sys.V_$TEMP_EXTENT_POOL p
WHERE  p.file_id(+) = h.file_id
AND    p.tablespace_name(+) = h.tablespace_name
GROUP BY h.tablespace_name
ORDER BY 1;


set linesize 200
col file_name format a50 heading "Datafile Name"
col allocated_mb format 999999.99;
col used_mob format 999999.99;
col free_mb format 999999.99;
col tablespace_name format a20;
SELECT SUBSTR (df.NAME, 1, 40) file_name, dfs. tablespace_name, df.bytes / 1024 / 1024 allocated_mb,
         ((df.bytes / 1024 / 1024) - NVL (SUM (dfs.bytes) / 1024 / 1024, 0))
               used_mb,  NVL (SUM (dfs.bytes) / 1024 / 1024, 0) free_mb, c.autoextensible
    FROM v$datafile df, dba_free_space dfs, DBA_DATA_FILES c
   WHERE df.file# = dfs.file_id(+) AND  df.file# = c.FILE_ID
GROUP BY dfs.file_id, df.NAME, df.file#, df.bytes, dfs.tablespace_name, c.autoextensible
ORDER BY file_name;

SELECT TO_CHAR(creation_time, 'RRRR Month') "Year/Month", 
round(SUM(bytes)/1024/1024/1024) "Datafile Growth Rate in GB" 
FROM sys.v_$datafile 
WHERE creation_time < sysdate
GROUP BY TO_CHAR(creation_time, 'RRRR Month');

TTI off

prompt
prompt** Report Tablespace < 10% free space**
prompt** -----------------------------------------------------------------------**
set pagesize 300;
set linesize 100;
column tablespace_name format a15 heading Tablespace;
column sumb format 999,999,999;
column extents format 9999;
column bytes format 999,999,999,999;
column largest format 999,999,999,999;
column Tot_Size format 999,999 Heading "Total Size(Mb)";
column Tot_Free format 999,999,999 heading "Total Free(Kb)";
column Pct_Free format 999.99 heading "% Free";
column Max_Free format 999,999,999 heading "Max Free(Kb)";
column Min_Add format 999,999,999 heading "Min space add (MB)";
select a.tablespace_name,sum(a.tots/1048576) Tot_Size,
sum(a.sumb/1024) Tot_Free, sum(a.sumb)*100/sum(a.tots) Pct_Free,
ceil((((sum(a.tots) * 15) - (sum(a.sumb)*100))/85 )/1048576) Min_Add
from (select tablespace_name,0 tots,sum(bytes) sumb
from sys.dba_free_space a
group by tablespace_name
union
select tablespace_name,sum(bytes) tots,0 from
sys.dba_data_files
group by tablespace_name) a
group by a.tablespace_name
having sum(a.sumb)*100/sum(a.tots) < 10
order by pct_free;

col owner format a15;
SELECT owner, count(*), tablespace_name
FROM dba_segments
WHERE tablespace_name = 'SYSTEM' AND owner NOT IN ('SYS','SYSTEM','CSMIG','OUTLN')
Group by owner, tablespace_name;

set pagesize 0;
prompt
SELECT   '+ '||count(*)||' NON-SYSTEM objects detected in SYSTEM tablespace with '||
                   'total size:  '||NVL(round(sum(bytes)/1024/1024,2),0)||'MB' "NON-SYSTEM objects"
FROM  dba_segments
WHERE  tablespace_name = 'SYSTEM' AND owner not in ('SYS','SYSTEM','CSMIG','OUTLN');

set pagesize 50;
col name  format A60 heading "Control Files";
select name from   sys.v_$controlfile;

prompt
set pagesize 0;
select (case
         when count(1) <2 then '+ At least 2 controlfiles are recommended'
         when count(1) >=2 and count(1) <=3 then '+ '||count(1)||' mirrors for controlfile detected. - OK' 
         else '+ More than 3 controlfiles might have additional overhead. Check the wait events.'
       end)
from v$controlfile;

set pagesize 0;
col msg format a79;
select 
(case when value <45 then '+ ! "control_file_record_keep_time='||value||'" to low. Set to at least 45'
else '+ "control_file_record_keep_time='||value||'"  - OK.'
end) msg
from v$parameter where name = 'control_file_record_keep_time';

set pagesize 50;
select segment_name, owner, tablespace_name, status from dba_rollback_segs;

prompt
set pagesize 0;
select 'The average of rollback segment waits/gets is '||  
   round((sum(waits) / sum(gets)) * 100,2)||'%'  
From    v$rollstat;

set pagesize 50;
SELECT TO_CHAR(SUM(value), '999,999,999,999,999') "Total Requests"
FROM  v$sysstat 
WHERE name IN ('db block gets','consistent gets');

set pagesize 50;
SELECT class  "Class", count  "Count"
FROM   v$waitstat 
WHERE  class IN (   'free list', 'system undo header', 'system undo block', 'undo header', 'undo block') 
GROUP BY   class, count;
prompt
prompt* If these are < 1% of Total Number of request for data then extra rollback segment are needed.

prompt  
prompt Check Rollback Contention:
prompt -----------------------------------------------------------------------**

select class, count, time from  v$waitstat
where class in ('data block', 'undo header', 'undo block', 'segment header');

prompt
prompt* If the contention is on 'data block' check for SQL statements using unselective indexes. 
prompt* if the contention is on 'undo header' consider using automatic segment-space management or add more rollback segments.
prompt* if the contention is on 'undo block' consider using automatic segment-space management or make rollback segment sizes larger.
prompt* If the contention is on 'segment header' look for the segment and consider increase free-lists.


set pagesize 50;
set line 200;
col member  format A40 heading "Redolog Files";
col group# format 99;
col archived format a3;
col status format a10;
col first_time format a12;
select a.group#, a.member, b.archived, b.status, b.first_time from v$logfile a, v$log b
where a.group# = b.group# order by a.group#;

prompt
set pagesize 0
select 'Group# '||group#||': '||
       (case 
          when members<2 then '+ Redo log mirroring is recommended'
          else ' '||members||' members detected. - OK'
        end)
from v$log
where members < 2;

set pagesize 0;
select 
       (case
          when count(*)>3 then '+ '||count(*)||' times detected when log switches occured more than 1 log per 5 minutes.'||chr(10)||
                                               '+ You may consider to increase the redo log size.'
          else '+ Redo log size: OK'
        end) "Redolog Size Status"
from (
select trunc(FIRST_TIME,'HH') Week, count(*) arch_no, trunc(10*count(*)/60) archpermin
from v$log_history
group by trunc(FIRST_TIME,'HH')
having trunc(5*count(*)/60)>1
);

set pagesize 0;
select (case  when sync_waits = 0 then '+ Waits for log file sync not detected: log_buffer is OK'
        else  '+ Waits for log file sync detected ('||sync_waits||' times): Consider to increase the log_buffer'
        end) "Log Buffer Status"
from ( select  decode(  sum(w.total_waits),  0, 0,
    nvl(100 * sum(l.total_waits) / sum(w.total_waits), 0)
  )  sync_waits
from  sys.v_$bgprocess  b,  sys.v_$session  s,  sys.v_$session_event  l,  sys.v_$session_event  w
where
  b.name like 'DBW_' and  s.paddr = b.paddr and
  l.sid = s.sid and  l.event = 'log file sync' and
  w.sid = s.sid and  w.event = 'db file parallel write'
);

prompt
prompt Last 24hrs Log switch Report:
prompt -----------------------------------------------------------------------**

set pagesize 0;
select '+ Daily (max) : '||max(no)||' switches. Size: '||round((max(no) * max(logsize )) ,2)||'MB'||chr(10)||
       '+ Daily (avg) : '||trunc(avg(no))||' switches. Size: '||round((avg(no) * max(logsize )) ,2)||'MB'||chr(10)||
       '+ Daily (min) : '||min(no)||' switches. Size: '||round((min(no) * max(logsize )) ,2)||'MB'
from (select trunc(FIRST_TIME,'DD'), count(*) no
from v$log_history
where FIRST_TIME > sysdate - 31
group by trunc(FIRST_TIME,'DD')),
(select max(bytes/1024/1024) logsize from v$log);

set pagesize 0;
select '+ Weekly (max): '||max(no)||' switches. Size: '||round((max(no) * max(logsize )) ,2)||'MB'||chr(10)||
       '+ Weekly (avg): '||trunc(avg(no))||' switches. Size: '||round((avg(no) * max(logsize )) ,2)||'MB'||chr(10)||
       '+ Weekly (min): '||min(no)||' switches. Size: '||round((min(no) * max(logsize )) ,2)||'MB'
from (select trunc(FIRST_TIME,'WW'), count(*) no
from v$log_history
where FIRST_TIME > sysdate - 31
group by trunc(FIRST_TIME,'WW')),
(select max(bytes/1024/1024) logsize from v$log);

set pagesize 25;
select trunc(completion_time) log_date, count(*) log_switch, round((sum(blocks*block_size) / 1024 / 1024)) "SIZE_MB"
from v$archived_log
WHERE  completion_time > (sysdate-1) - 1/24 AND DEST_ID = 1
group by trunc(completion_time)
order by 1 desc;

set line 200;
col event format a30; 
col "time_waited" heading time|waited;
col "average_wait" heading average|wait;
select  event, time_waited "time_waited", average_wait "average_wait"
    from v$system_event
    where event like 'log file switch completion';

prompt
prompt * The pct_buff_retries should be 0 or (< 1%) . If it is greater consider moving the logfile to faster disk.
prompt * If there are log file switch waits, it indicates disk I/O contention. Check that redo log files are stored on separated and fast devices.

prompt
prompt
prompt**====================================================================================================**
prompt**    **Database Users Activities**
prompt**====================================================================================================**

set pagesize 100;
set line 200;
col username format a20;
col profile format a10;
col default_ts# format a18;
col temp_ts# format a10;
col created format a12;
Select username, account_status status, TO_CHAR(created, 'dd-MON-yyyy') created, profile, 
default_tablespace default_ts#, temporary_tablespace temp_ts# from dba_users
where default_tablespace in ('SDH_HRMS_DBF', 'SDH_TIMS_DBF', 'SDH_SHTR_DBF', 'SDH_EDSS_DBF', 'SDH_FIN_DBF', 'SDH_FIN_DBF', 'USERS');

select    obj.owner "USERNAME",  obj_cnt "Objects", decode(seg_size, NULL, 0, seg_size) "Size_MB"
from (select owner, count(*) obj_cnt from dba_objects group by owner) obj,
(select owner, ceil(sum(bytes)/1024/1024) seg_size
from dba_segments group by owner) seg
where obj.owner  = seg.owner(+)
order by 3 desc,2 desc, 1;

col status format a20  heading "Session status";
col TOTAL format 9999999999  heading "# sessions";
select status, count(*) TOTAL from gv$session
where type='USER'
group by inst_id,status
order by 1,2;

set line 200;
col LOGON_TIME format a10;
col sid format 99;
col status format a8;
col process format a12;
col SCHEMANAME format a12;
col OSUSER format a15;
col machine format a25;
col SQL_TEXT format a75;
SELECT S.LOGON_TIME, s.sid, s.process,   s.schemaname, s.osuser, s.MACHINE, a.sql_text
FROM   v$session s, v$sqlarea a, v$process p
WHERE  s.SQL_HASH_VALUE = a.HASH_VALUE
AND    s.SQL_ADDRESS = a.ADDRESS
AND    s.PADDR = p.ADDR
AND S.STATUS = 'INACTIVE';


prompt
prompt
prompt**==================================================================================================**
prompt**      **Database Object Information**
prompt**==================================================================================================**

prompt
prompt List of Largest Object in Database:
prompt -----------------------------------------------------------------------**
set line 200;
col SEGMENT_NAME format a30;
col SEGMENT_TYPE format a10;
col BYTES format a15;
col TABLESPACE_NAME FORMAT A25;
SELECT * FROM (select SEGMENT_NAME, SEGMENT_TYPE TYPE, BYTES/1024/1024 SIZE_MB, 
TABLESPACE_NAME from dba_segments order by 3 desc ) WHERE ROWNUM <= 5;

prompt
prompt Object Modified in last 7 days:
prompt -----------------------------------------------------------------------**

set line 200;
col owner format a15;
col object_name format a25;
col object_type format a15;
col last_modified format a20;
col created format a20;
col status format a10;
select owner, object_name, object_type, to_char(LAST_DDL_TIME,'MM/DD/YYYY HH24:MI:SS') last_modified,
    to_char(CREATED,'MM/DD/YYYY HH24:MI:SS') created, status
from  dba_objects
where (SYSDATE - LAST_DDL_TIME) < 7 and owner IN( 'HRMS', 'ORAFIN', 'HRTRAIN')
order by last_ddl_time DESC;

prompt
set pagesize 0;
SELECT 'Object Created in this Week: '|| count(1) from user_objects
where created >= sysdate -7;

prompt
prompt List of Invalid objects of database:
prompt -----------------------------------------------------------------------**

set pagesize 50;
Select owner "USERNAME", object_type, count(*) INVALID from dba_objects 
where status='INVALID' group by  owner, object_type;

set pagesize 50;
SELECT dt.owner, dt.table_name "Table Change > 10%",
       ROUND ( (DELETES + UPDATES + INSERTS) / num_rows * 100) PERCENTAGE
FROM   dba_tables dt, all_tab_modifications atm
WHERE  dt.owner = atm.table_owner
       AND dt.table_name = atm.table_name
       AND num_rows > 0
       AND ROUND ( (DELETES + UPDATES + INSERTS) / num_rows * 100) >= 10
ORDER BY 3 desc;

prompt
prompt Database Chained Rows Info:
prompt -----------------------------------------------------------------------**

col table_name format a25;
select owner, table_name, pct_free, pct_used, avg_row_len, num_rows, chain_cnt, trunc(chain_cnt/num_rows*100, 2) as perc 
from dba_tables where owner not in ('SYS','SYSTEM') 
and table_name not in (select table_name from dba_tab_columns
where data_type in ('RAW','LONG RAW') )
and chain_cnt > 0 order by chain_cnt desc;

prompt
prompt
prompt**==================================================================================================**
prompt**     **RMAN Configuration and Backup**
prompt**==================================================================================================**

col "RMAN CONFIGURE PARAMETERS" format a100;
select  'CONFIGURE '||name ||' '|| value "RMAN CONFIGURE PARAMETERS"
from  v$rman_configuration
order by conf#;

set line 200;
col "DEVIC" format a6;
col "L" format 9;
col "FIN:SS" format 9999; 
SELECT  DECODE(backup_type, 'L', 'Archived Logs', 'D', 'Datafile Full', 'I', 'Incremental')
 backup_type, bp.tag "RMAN_BACKUP_TAG", device_type "DEVIC", DECODE( bs.controlfile_included, 'NO', null, bs.controlfile_included) controlfile, 
 (sp.spfile_included) spfile, sum(bs.incremental_level) "L", TO_CHAR(bs.start_time, 'dd/mm/yyyy HH24:MI:SS') start_time
  , TO_CHAR(bs.completion_time, 'dd/mm/yyyy HH24:MI:SS')  completion_time, sum(bs.elapsed_seconds) "FIN:SS"
FROM v$backup_set  bs,  (select distinct  set_stamp, set_count, tag , device_type
     from v$backup_piece
     where status in ('A', 'X'))  bp,  
     (select distinct  set_stamp , set_count , 'YES'  spfile_included
     from v$backup_spfile) sp
WHERE bs.start_time > sysdate - 1
AND bs.set_stamp = bp.set_stamp
AND bs.set_count = bp.set_count
AND bs.set_stamp = sp.set_stamp (+)
AND bs.set_count = sp.set_count (+)
group by backup_type, bp.tag, device_type, bs.controlfile_included, pieces, sp.spfile_included,start_time, bs.completion_time
ORDER BY bs.start_time desc;

set line 200;
col "DBF_BACKUP_MB" format 999999.99;
col "ARC_BACKUP_MB" format 9999.99; 
select trunc(completion_time) "BAK_DATE", sum(blocks*block_size)/1024/1024 "DBF_BACKUP_MB", (SELECT sum(blocks*block_size)/1024/1024  from v$backup_redolog
WHERE first_time > sysdate-1) "ARC_BACKUP_MB"
from v$backup_datafile
WHERE completion_time > sysdate - 1
group by trunc(completion_time)
order by 1 DESC;

col "Datafiles backed up within 24h" format a40;
col "Control backed up" format 999;
col "SPFiles backed up" format 999;
SELECT dbfiles||' out of '||numfiles||' datafiles backed up' "Datafiles backed up within 24h", cfiles "CFiles", spfiles "SPFiles"
 FROM    (select count(*) numfiles from v$datafile), (select count(*) dbfiles  from v$backup_datafile a, v$datafile b
 where a.file# = b.file#   and a.completion_time > sysdate - 1), (select count(*) cfiles from v$backup_datafile
 where file# = 0 and completion_time > sysdate - 1), (select count(*) spfiles from v$backup_spfile where completion_time > sysdate - 1);


prompt
prompt
prompt**===================================================================================================**
prompt**        "Workload and I/O Statistics**
prompt**===================================================================================================**
prompt
prompt *** TOP SYSTEM Timed Events (Waits):
prompt*-----------------------------------------------------------------------**
COLUMN event       FORMAT A40           HEADING "Wait Event"  TRUNC
COLUMN time_waited FORMAT 9999999999999 HEADING "Time|Waited"
COLUMN wait_pct    FORMAT 99.90         HEADING "Wait|(%)"
SELECT  w.event, w.time_waited, round(w.time_waited/tw.twt*100,2) wait_pct
FROM  gv$system_event w, (select inst_id, sum(time_waited) twt  from gv$system_event
  where time_waited>0
   AND event NOT IN ('Null event', 'client message', 'rdbms ipc reply', 'smon timer', 'rdbms ipc message', 'PX Idle Wait', 'PL/SQL lock timer', 'file open', 'pmon timer', 'WMON goes to sleep',
 'virtual circuit status', 'dispatcher timer', 'SQL*Net message from client', 'parallel query dequeue wait', 'pipe get')  
  group by inst_id
  ) tw 
WHERE  w.inst_id = tw.inst_id and w.time_waited>0
 and round(w.time_waited/tw.twt*100,2) > 1
 and w.event NOT IN ('Null event', 'client message', 'rdbms ipc reply', 'smon timer', 'rdbms ipc message', 'PX Idle Wait', 'PL/SQL lock timer', 'file open', 'pmon timer', 'WMON goes to sleep',
 'virtual circuit status', 'dispatcher timer', 'SQL*Net message from client', 'parallel query dequeue wait', 'pipe get')
ORDER by 1;

prompt
prompt *** Most buffer gets (TOP 5):
prompt*-----------------------------------------------------------------------**

col object_type format a10;
col object_name format a30;
col statistic_name format a15;
col value format 99999999999;
SELECT * from ( 
SELECT object_type, object_name, statistic_name,VALUE
  FROM v$segment_statistics
  WHERE statistic_name LIKE '%logi%' AND VALUE > 50
  ORDER BY 4 DESC
) where rownum < 6;

prompt
prompt *** Most I/O operation (TOP 5):
prompt*-----------------------------------------------------------------------**
col object_type    format a15         heading "Object Type"
col object_name    format a27         heading "Object Name"
col statistic_name format a22         heading "Statistic Name"
col value     format 99999999999 heading "Value"
SELECT * from ( 
SELECT object_type, object_name, statistic_name, VALUE
  FROM v$segment_statistics
  WHERE statistic_name LIKE '%phys%' AND VALUE > 50
  ORDER BY 4 DESC
) where rownum < 6;

prompt
prompt *** Most I/O operation for particualr Query:
prompt*-----------------------------------------------------------------------**

col sql_text format a60;
col reads_per_exe format 99999999 heading 'reads|per_exe';
col "exe" format 99999;
col "sorts" format 99999;
col buffer_gets heading 'buffer|gets';
col disk_reads heading  'disk|reads';
SELECT * FROM   (SELECT Substr(a.sql_text,1,50) sql_text, 
Trunc(a.disk_reads/Decode(a.executions,0,1,a.executions)) reads_per_exe, 
a.buffer_gets, a.disk_reads, a.executions "exe", a.sorts "sorts", a.address "address"
FROM   v$sqlarea a
ORDER BY 2 DESC)
WHERE  rownum <= 5;

prompt
prompt Monitoring Full Table Scan of Database:
prompt*-----------------------------------------------------------------------**

set line 200;
col "Full Table Scan" format a30;
SELECT name "Full Table Scan", value FROM v$sysstat
WHERE name LIKE '%table scans %'
ORDER BY name;

prompt
Prompt* Review the query causing high amount of buffer_gets and create additional index to avoid full table scan.

prompt
prompt Monitor TOP CPU  Usage and Logical I/O Process:
prompt*-----------------------------------------------------------------------**

col resource_name heading "Resource|Name";
col current_utilization  heading "current|utiliz";
col max_utilization  heading "Max|utiliz";
col initial_allocation  heading "Initial|Alloc";
col limit_value  heading "Limit|Value";
select resource_name, current_utilization, max_utilization, initial_allocation, limit_value
from v$resource_limit where resource_name in ('processes','sessions', 'transactions', 'max_rollback_segments');

col name format a30;
select * from (select a.sid, c.username, c.osuser, c.machine,  logon_time, b.name,  a.value
from   v$sesstat  a, v$statname b,  v$session  c
where a.STATISTIC# = b.STATISTIC#
and   a.sid = c.sid
and   b.name like '%CPU used by this session%'
order by a.value desc)
where rownum < 5;

select 'top logical i/o process', sid, username,  total_user_io amt_used, round(100 * total_user_io/total_io,2) pct_used
from (select b.sid sid, nvl(b.username, p.name) username, sum(value) total_user_io
      from v$statname c, v$sesstat a,   v$session b, v$bgprocess p
      where a.statistic# = c.statistic#   and p.paddr (+) = b.paddr   and b.sid = a.sid
      and c.name in ('consistent gets', 'db block gets')  and b.username not in ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP')
      group by b.sid, nvl(b.username, p.name)  order by 3 desc),
     (select sum(value) total_io  from v$statname c, v$sesstat a,  v$session b, v$bgprocess p
      where a.statistic# = c.statistic#   and p.paddr (+) = b.paddr and b.sid = a.sid  and c.name in ('consistent gets', 'db block gets'))
where rownum < 2
union all
select 'top memory process', sid, username, total_user_mem,  round(100 * total_user_mem/total_mem,2)
from (select b.sid sid, nvl(b.username, p.name) username, sum(value) total_user_mem
      from v$statname c, v$sesstat a,  v$session b, v$bgprocess p
      where a.statistic# = c.statistic#  and p.paddr (+) = b.paddr
      and b.sid = a.sid  and c.name in ('session pga memory', 'session uga memory')
      and b.username not in ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP')
      group by b.sid, nvl(b.username, p.name)   order by 3 desc),
     (select sum(value) total_mem from v$statname c, v$sesstat a
      where a.statistic# = c.statistic#  and c.name in ('session pga memory', 'session uga memory'))
where rownum < 2
union all
select 'top cpu process', sid, username, total_user_cpu, round(100 * total_user_cpu/greatest(total_cpu,1),2)
from (select b.sid sid, nvl(b.username, p.name) username, sum(value) total_user_cpu
      from v$statname c, v$sesstat a, v$session b, v$bgprocess p
      where a.statistic# = c.statistic#  and p.paddr (+) = b.paddr  and b.sid = a.sid
      and c.name = 'CPU used by this session'  and b.username not in ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP')
      group by b.sid, nvl(b.username, p.name)  order by 3 desc),
     (select sum(value) total_cpu  from v$statname c, v$sesstat a,  v$session b, v$bgprocess p
      where a.statistic# = c.statistic#  and p.paddr (+) = b.paddr  and b.sid = a.sid
      and c.name = 'CPU used by this session') where rownum < 2;

prompt
prompt Monitoring Current Running Long Job in Database:
prompt*-----------------------------------------------------------------------**

set line 200;
col opname format a30;
SELECT SID, SERIAL#, opname, SOFAR, TOTALWORK,
ROUND(SOFAR/TOTALWORK*100,2) COMPLETE
FROM   V$SESSION_LONGOPS
WHERE TOTALWORK != 0 AND SOFAR != TOTALWORK 
order by 1;

prompt
prompt Monitoring Object locking:
prompt*-----------------------------------------------------------------------**
set line 200;
col username format a15;
col lock_type format a10;
col osuser format a15;
col owner format a10;
col object_name format a20;
SELECT s.sid, s. serial#, s.username, l.lock_type, s.osuser, s.machine,
o.owner, o.object_name, ROUND(w.seconds_in_wait/60, 2) "Wait"                  
FROM v$session s, dba_locks l, dba_objects o, v$session_wait  w
WHERE   s.sid = l.session_id
  AND l.lock_type IN ('DML','DDL')AND l.lock_id1 = o.object_id
  AND l.session_id = w.sid
  ORDER BY   s.sid;

prompt
prompt Monitor DB Corruption or Need of Recovery:
prompt*-----------------------------------------------------------------------**
set line 200;
SELECT r.FILE# AS df#, d.NAME AS df_name, t.NAME AS tbsp_name, d.STATUS,
    r.ERROR, r.CHANGE#, r.TIME FROM V$RECOVER_FILE r, V$DATAFILE d, V$TABLESPACE t
    WHERE t.TS# = d.TS# AND d.FILE# = r.FILE#;

set linesize 200
col name format a45 heading "Datafile Name";
col "Read Time(ms)" heading 'Read|Time(ms)';
col "Write Time(ms)" heading 'write|Time(ms)';
col "Avg_Time" heading 'Avg|Time(ms)';
select name,PHYRDS,PHYWRTS,READTIM "Read Time(ms)",WRITETIM "Write Time(ms)",AVGIOTIM "Avg_Time" 
from v$filestat, v$datafile where v$filestat.file#=v$datafile.file#;
set feedback on
prompt
rem -----------------------------------------------------------------------
rem Filename:   DB_Health_Rep.sql
rem Purpose:    Database Statistics and Health Report
rem -----------------------------------------------------------------------
prompt Recommendations:
prompt ====================================================================================================
prompt* SQL Cache Hit rate ratio should be above 90%, if not then increase the Shared Pool Size.
prompt* Dict Cache Hit rate ratio should be above 85%, if not then increase the Shared Pool Size.
prompt* Buffer Cache Hit rate ratio should be above 90%, if not then increase the DB Block Buffer value.
prompt* Redo Log space requests should be less than 0.5% of redo entries, if not then increase log buffer.
prompt* Redo Log space wait time should be near to 0.
prompt
set serveroutput ON
DECLARE
      libcac number(10,2);
      rowcac number(10,2);
      bufcac number(10,2);
      redlog number(10,2);
      redoent number;
      redowaittime number;
BEGIN
select value into redlog from v$sysstat where name = 'redo log space requests';
select value into redoent from v$sysstat where name = 'redo entries';
select value into redowaittime from v$sysstat where name = 'redo log space wait time';
select 100*(sum(pins)-sum(reloads))/sum(pins) into libcac from v$librarycache;
select 100*(sum(gets)-sum(getmisses))/sum(gets) into rowcac from v$rowcache;
select 100*(cur.value + con.value - phys.value)/(cur.value + con.value) into bufcac
from v$sysstat cur,v$sysstat con,v$sysstat phys,v$statname ncu,v$statname nco,v$statname nph
where cur.statistic# = ncu.statistic#
        and ncu.name = 'db block gets'
        and con.statistic# = nco.statistic#
        and nco.name = 'consistent gets'
        and phys.statistic# = nph.statistic#
        and nph.name = 'physical reads';
dbms_output.put_line('CACHE HIT RATE');
dbms_output.put_line('********************');
dbms_output.put_line('SQL Cache Hit rate = '||libcac);
dbms_output.put_line('Dict Cache Hit rate = '||rowcac);
dbms_output.put_line('Buffer Cache Hit rate = '||bufcac);
dbms_output.put_line('Redo Log space requests = '||redlog);
dbms_output.put_line('Redo Entries = '||redoent);
dbms_output.put_line('Redo log space wait time = '||redowaittime);
if
 libcac < 90  then dbms_output.put_line('*** HINT: Library Cache too low! Increase the Shared Pool Size.');
END IF;
if
 rowcac < 85  then dbms_output.put_line('*** HINT: Row Cache too low! Increase the Shared Pool Size.');
END IF;
if
 bufcac < 90  then dbms_output.put_line('*** HINT: Buffer Cache too low! Increase the DB Block Buffer value.');
END IF;
if
 redlog > 1000000 then dbms_output.put_line('*** HINT: Log Buffer value is rather low!');
END IF;
END;
/
spool off
exit
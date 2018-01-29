spool c:\tmp\report.txt

select 'LIBRARY CACHE STATISTICS:' from dual;  

set pages 1000
 

 
select 'PINS - # of times an item in the library cache was executed - '||  
        sum(pins),  
       'RELOADS - # of library cache misses on execution steps - '|| 
        sum (reloads),  
       'RELOADS / PINS * 100 = '||round((sum(reloads) / sum(pins) *  
100),2)||'%' 
from    v$librarycache  
/  
 
prompt Increase memory until RELOADS is near 0 but watch out for  
prompt Paging/swapping 
prompt To increase library cache, increase SHARED_POOL_SIZE  
prompt  
prompt ** NOTE: Increasing SHARED_POOL_SIZE will increase the SGA size.  
prompt  
prompt Library Cache Misses indicate that the Shared Pool is not big  
prompt enough to hold the shared SQL area for all concurrently open cursors.  
prompt If you have no Library Cache misses (PINS = 0), you may get a small  
prompt increase in performance by setting CURSOR_SPACE_FOR_TIME = TRUE which  
prompt prevents ORACLE from deallocating a shared SQL area while an  
prompt application  
prompt cursor associated with it is open.  
prompt  
prompt For Multi-threaded server, add 1K to SHARED_POOL_SIZE per user.  
prompt  
prompt------------------------------------------------------------------------  
  
column xn1 format a50  
column xn2 format a50  
column xn3 format a50  
column xv1 new_value xxv1 noprint  
column xv2 new_value xxv2 noprint  
column xv3 new_value xxv3 noprint  
column d1  format a50  
column d2  format a50  
 
prompt HIT RATIO:  
prompt  
prompt Values Hit Ratio is calculated against:  
prompt  
 
select lpad(name,20,' ')||'  =  '||value xn1, value xv1  
from   v$sysstat  
where  name = 'db block gets'  
/  
 
select lpad(name,20,' ')||'  =  '||value xn2, value xv2   
from   v$sysstat  
where  name = 'consistent gets'  
/  
 
select lpad(name,20,' ')||'  =  '||value xn3, value xv3   
from   v$sysstat b  
where  name = 'physical reads'  
/  
 

 
select 'Logical reads = db block gets + consistent gets ',  
        lpad ('Logical Reads = ',24,' ')||to_char(&xxv1+&xxv2) d1  
from    dual  
/  
 
select 'Hit Ratio = (logical reads - physical reads) / logical reads',  
        lpad('Hit Ratio = ',24,' ')||  
        round( (((&xxv2+&xxv1) - &xxv3) / (&xxv2+&xxv1))*100,2 )||'%' d2  
from    dual  
/  
 
prompt If the hit ratio is less than 60%-70%, increase the initialization  
prompt parameter DB_BLOCK_BUFFERS.  ** NOTE:  Increasing this parameter will  
prompt increase the SGA size.  
prompt  
prompt------------------------------------------------------------------------  
  
col name format a30  
col gets format 9,999,999,999  
col waits format 9,999,999,999  
 
prompt ROLLBACK CONTENTION STATISTICS:  
prompt  
  
prompt GETS - # of gets on the rollback segment header 
prompt WAITS - # of waits for the rollback segment header  
  
set head on;  
 
select name, waits, gets  
from   v$rollstat, v$rollname  
where  v$rollstat.usn = v$rollname.usn  
/  
 
set head off  
 
select 'The average of waits/gets is '||  
   round((sum(waits) / sum(gets)) * 100,2)||'%'  
From    v$rollstat  
/  
  
prompt  
prompt If the ratio of waits to gets is more than 1% or 2%, consider  
prompt creating more rollback segments  
prompt  
prompt Another way to gauge rollback contention is:  
prompt  
  
column xn1 format 9999999  
column xv1 new_value xxv1 noprint  
 
set head on  
 
select class, count  
from   v$waitstat  
where  class in ('system undo header', 'system undo block', 
                 'undo header',        'undo block'          )  
/  
 
set head off  
 
select 'Total requests = '||sum(count) xn1, sum(count) xv1  
from    v$waitstat  
/  
 
select 'Contention for system undo header = '||  
       (round(count/(&xxv1+0.00000000001),4)) * 100||'%'  
from  v$waitstat  
where   class = 'system undo header'  
/  
 
select 'Contention for system undo block = '||  
       (round(count/(&xxv1+0.00000000001),4)) * 100||'%'  
from    v$waitstat  
where   class = 'system undo block'  
/  
 
select 'Contention for undo header = '||  
       (round(count/(&xxv1+0.00000000001),4)) * 100||'%'  
from    v$waitstat  
where   class = 'undo header'  
/  
 
select 'Contention for undo block = '||  
       (round(count/(&xxv1+0.00000000001),4)) * 100||'%'  
from    v$waitstat  
where   class = 'undo block'  
/  
 
prompt  
prompt If the percentage for an area is more than 1% or 2%, consider  
prompt creating more rollback segments.  Note:  This value is usually very  
prompt small 
prompt and has been rounded to 4 places.  
prompt  
prompt------------------------------------------------------------------------  
  
prompt REDO CONTENTION STATISTICS:  
prompt  
prompt The following shows how often user processes had to wait for space in  
prompt the redo log buffer:  
  
select name||' = '||value  
from   v$sysstat  
where  name = 'redo log space requests'  
/  
 
prompt  
prompt This value should be near 0.  If this value increments consistently,  
prompt processes have had to wait for space in the redo buffer.  If this  
prompt condition exists over time, increase the size of LOG_BUFFER in the  
prompt init.ora file in increments of 5% until the value nears 0.  
prompt ** NOTE: increasing the LOG_BUFFER value will increase total SGA size.  
prompt  
prompt -----------------------------------------------------------------------  
  
  
col name format a15  
col gets format 9999999999999  
col misses format 999999999999  
col immediate_gets heading 'IMMED GETS' format 999999999999  
col immediate_misses heading 'IMMED MISS' format 99999999999  
col sleeps format 9999999999  
 
prompt LATCH CONTENTION:  
prompt  
prompt GETS - # of successful willing-to-wait requests for a latch  
prompt MISSES - # of times an initial willing-to-wait request was unsuccessful  
prompt IMMEDIATE_GETS - # of successful immediate requests for each latch  
prompt IMMEDIATE_MISSES = # of unsuccessful immediate requests for each latch  
prompt SLEEPS - # of times a process waited and requests a latch after an  
prompt          initial willing-to-wait request  
prompt  
prompt If the latch requested with a willing-to-wait request is not  
prompt available, the requesting process waits a short time and requests  
prompt again.  
prompt If the latch requested with an immediate request is not available,  
prompt the requesting process does not wait, but continues processing  
prompt  
  
set head on  
 
select name,          gets,              misses,  
       immediate_gets,  immediate_misses,  sleeps  
from   v$latch  
where  name in ('redo allocation',  'redo copy')  
/  
 
set head off  
 
select 'Ratio of MISSES to GETS: '||  
        round((sum(misses)/(sum(gets)+0.00000000001) * 100),2)||'%'  
from    v$latch  
where   name in ('redo allocation',  'redo copy')  
/  
 
select 'Ratio of IMMEDIATE_MISSES to IMMEDIATE_GETS: '||  
        round((sum(immediate_misses)/  
       (sum(immediate_misses+immediate_gets)+0.00000000001) * 100),2)||'%'  
from    v$latch  
where   name in ('redo allocation',  'redo copy')  
/  
 
prompt  
prompt If either ratio exceeds 1%, performance will be affected.  
prompt  
prompt Decreasing the size of LOG_SMALL_ENTRY_MAX_SIZE reduces the number of  
prompt processes copying information on the redo allocation latch.  
prompt  
prompt Increasing the size of LOG_SIMULTANEOUS_COPIES will reduce contention  
prompt for redo copy latches.  
  
rem  
rem This shows the library cache reloads  
rem  
 
set head on  
 
prompt  
prompt------------------------------------------------------------------------  
  
prompt  
prompt Look at gethitratio and pinhit ratio  
prompt  
prompt GETHITRATIO is number of GETHTS/GETS  
prompt PINHIT RATIO is number of PINHITS/PINS - number close to 1 indicates  
prompt that most objects requested for pinning have been cached.  Pay close  
prompt attention to PINHIT RATIO.  
prompt  
  
column namespace    format a20   heading 'NAME'  
column gets         format 999999999999 heading 'GETS'  
column gethits      format 999999999999 heading 'GETHITS'  
column gethitratio  format 999,999,999.99   heading 'GET HIT|RATIO'  
column pins         format 9999999999999  heading 'PINHITS'  
column pinhitratio  format 999,999,999.99   heading 'PIN HIT|RATIO'  
 
select namespace,    gets,  gethits,  
       gethitratio,  pins,  pinhitratio  
from   v$librarycache  
/  
 
rem  
rem  
rem This looks at the dictionary cache miss rate  
rem  
 
prompt  
prompt------------------------------------------------------------------------  
  
prompt THE DATA DICTIONARY CACHE:  
prompt  
prompt  
prompt Consider keeping this below 5% to keep the data dictionary cache in  
prompt the SGA.  Up the SHARED_POOL_SIZE to improve this statistic. **NOTE:  
prompt increasing the SHARED_POOL_SIZE will increase the SGA.  
prompt  
 
column dictcache format 999.99 heading 'Dictionary Cache | Ratio %'  
 
select sum(getmisses) / (sum(gets)+0.00000000001) * 100 dictcache  
from   v$rowcache  
/  
 
prompt  
prompt------------------------------------------------------------------------  
  
rem  
rem  
rem This looks at the sga area breakdown  
rem  
 
prompt THE SGA AREA ALLOCATION:  
prompt  
prompt  
prompt This shows the allocation of SGA storage.  Examine this before and  
prompt after making changes in the INIT.ORA file which will impact the SGA.  
prompt  
 
col name format a40  
 
select name, bytes  
from   v$sgastat
order by 2 desc
/  
 
set head off  
 
select 'total of SGA                            '||sum(bytes)  
from    v$sgastat  
/ 
 
prompt  
prompt------------------------------------------------------------------------  
  
prompt  
prompt -----------------------------------------------------------------------  
  

set space 3;  
set heading on;  
 
prompt  
prompt Parse Ratio usually falls between 1.15 and 1.45.  If it is higher, then  
prompt it is usually a sign of poorly written Pro* programs or unoptimized  
prompt SQL*Forms applications.  
prompt  
prompt Recursive Call Ratio will usually be between  
prompt  
prompt   7.0 - 10.0 for tuned production systems  
prompt  10.0 - 14.5 for tuned development systems  
prompt  
prompt Buffer Hit Ratio is dependent upon RDBMS size, SGA size and  
prompt the types of applications being processed.  This shows the %-age  
prompt of logical reads from the SGA as opposed to total reads - the  
prompt figure should be as high as possible.  The hit ratio can be raised  
prompt by increasing DB_BUFFERS, which increases SGA size.  By turning on  
prompt the "Virtual Buffer Manager" (db_block_lru_statistics = TRUE and  
prompt db_block_lru_extended_statistics = TRUE in the init.ora parameters),  
prompt you can determine how many extra hits you would get from memory as  
prompt opposed to physical I/O from disk.  **NOTE:  Turning these on will  
prompt impact performance.  One shift of statistics gathering should be enough  
prompt to get the required information.  
prompt  
  
Prompt Ratios for this instance:
 
column pcc   heading 'Parse|Ratio'       format 999,999,999.99  
column rcc   heading 'Recsv|Cursr'       format 999,999,999.99
column hr    heading 'Buffer|Ratio'      format 999,999,999,999,999.999  
column rwr   heading 'Rd/Wr|Ratio'       format 999,999,999.99
column bpfts heading 'Blks per|Full TS'  format 999,999,999.99
 
REM Modified for O7.1 to reverse 'cumulative opened cursors' to  
REM 'opened cursors cumulative'  
REM was:sum(decode(a.name,'cumulative opened cursors',value, .00000000001))  
REM pcc,  
REM and:sum(decode(a.name,'cumulative opened cursors',value,.00000000001))  
REM rcc,  
 
select sum(decode(a.name,'parse count',value,0)) /  
       sum(decode(a.name,'opened cursors cumulative',value,.00000000001)) pcc,  
       sum(decode(a.name,'recursive calls',value,0)) /  
       sum(decode(a.name,'opened cursors cumulative',value,.00000000001)) rcc,  
       (1-(sum(decode(a.name,'physical reads',value,0)) /  
       sum(decode(a.name,'db block gets',value,.00000000001)) +  
  sum(decode(a.name,'consistent gets',value,0))) * (-1)) hr,  
       sum(decode(a.name,'physical reads',value,0)) /  
       sum(decode(a.name,'physical writes',value,.00000000001)) rwr,  
       (sum(decode(a.name,'table scan blocks gotten',value,0)) -  
       sum(decode(a.name,'table scans (short tables)',value,0)) * 4) /  
       sum(decode(a.name,'table scans (long tables)',value,.00000000001))  
bpfts  
from   v$sysstat a  
/  

prompt  
prompt****************************************************  
prompt SQL Summary Section  
prompt****************************************************  
prompt  
column "Tot SQL run since startup" format 999,999,999,999,999  
column "SQL executing now"  format 999,999,999,999,999  
select sum(executions) "Tot SQL run since startup",  
                sum(users_executing) "SQL executing now"  
                from v$sqlarea;  

prompt  
prompt  
prompt        =========================  
prompt        DISPATCHER USAGE  
prompt        =========================  
prompt (If Time Busy > 50, then change 
prompt        MTS_MAX_DISPATCHERS in init.ora)  
column "Time Busy" format 999,999,999.999  
column busy  format 999,999,999,999  
column idle  format 999,999,999,999  
select name, status, idle, busy,  
 (busy/(busy+idle))*100 "Time Busy"  
from v$dispatcher;  
  
 prompt  
 prompt  
 select count(*) "Shared Server Processes"  
  from v$shared_server  
  where status = 'QUIT';  
  
 prompt  
 prompt  
 prompt high-water mark for the multi-threaded server  
 prompt  
  
 select * from v$mts;  
  
SET    TERMOUT OFF
COL    session format a50
COL    sort_column NEW_VALUE sort_order
COL    pga_column  NEW_VALUE show_pga
COL    uga_column  NEW_VALUE show_uga
COL    snap_column NEW_VALUE snap_time


PROMPT
PROMPT   :::::::::::::::::::::::::::::::::: PROGRAM GLOBAL AREA statistics :::::::::::::::::::::::::::::::::
Select * from (
SELECT   to_char(ssn.sid, '9999') || '-' || nvl(ssn.username, nvl(bgp.name, 'background')) ||'-'||
                  nvl(lower(ssn.machine), ins.host_name) "SESSION",
             to_char((se1.value/1024)/1024, '999G999G990D00') || ' MB' "      CURRENT SIZE",
             to_char((se2.value/1024)/1024, '999G999G990D00') || ' MB' "      MAXIMUM SIZE",
             ssn.sql_hash_value
    FROM     v$sesstat se1, v$sesstat se2, v$session ssn, v$bgprocess bgp, v$process prc,
          v$instance ins,  v$statname stat1, v$statname stat2
 WHERE    se1.statistic# = stat1.statistic# and stat1.name = 'session pga memory'
 AND      se2.statistic#  = stat2.statistic# and stat2.name = 'session pga memory max'
 AND      se1.sid        = ssn.sid
 AND      se2.sid        = ssn.sid
 AND	  ssn.status='ACTIVE' AND ssn.username is not null
 AND      ssn.paddr      = bgp.paddr (+)
 AND      ssn.paddr      = prc.addr  (+)
ORDER BY 2 DESC) where rownum <6
/

Select * from (
SELECT   to_char(ssn.sid, '9999') || '-' || nvl(ssn.username, nvl(bgp.name, 'background')) ||'-'||
                  nvl(lower(ssn.machine), ins.host_name) "SESSION",
             to_char((se1.value/1024)/1024, '999G999G990D00') || ' MB' "      CURRENT SIZE",
             to_char((se2.value/1024)/1024, '999G999G990D00') || ' MB' "      MAXIMUM SIZE",
             ssn.last_call_et
    FROM     v$sesstat se1, v$sesstat se2, v$session ssn, v$bgprocess bgp, v$process prc,
          v$instance ins,  v$statname stat1, v$statname stat2
 WHERE    se1.statistic# = stat1.statistic# and stat1.name = 'session pga memory'
 AND      se2.statistic#  = stat2.statistic# and stat2.name = 'session pga memory max'
 AND      se1.sid        = ssn.sid
 AND      se2.sid        = ssn.sid
 AND	  ssn.status='INACTIVE' AND ssn.username is not null
 AND      ssn.paddr      = bgp.paddr (+)
 AND      ssn.paddr      = prc.addr  (+)
ORDER BY 4 DESC) where rownum <6
/


DEFINE blocks_read = 10000 (NUMBER)
COLUMN parsing_user_id  FORMAT 9999999999     HEADING 'User Id'
COLUMN executions       FORMAT 999999999        HEADING 'Exec'
COLUMN sorts            FORMAT 999999999       HEADING 'Sorts'
COLUMN command_type     FORMAT 999999999       HEADING 'CmdT'
COLUMN disk_reads       FORMAT 999,999,999 HEADING 'Block Reads'
COLUMN sql_text         FORMAT a40         HEADING 'Statement' WORD_WRAPPED
SET LINES 130

select * from (
SELECT hash_value, executions, round(sorts/executions) sorts, round(disk_reads/executions) disk_reads, sql_text
  FROM v$sqlarea
 WHERE disk_reads > 10000
 ORDER BY 4 desc) where rownum <6;


set lines 132

set feed off
col A format a10 heading "Month"
col B format a30 heading "Archive Date"
col C format 999 heading "Switches"

compute AVG of C on A
compute AVG of C on REPORT

Prompt AVG. Switch Redo Logs:

select 
	to_char(trunc(first_time), 'Month') A ,
	to_char(trunc(first_time), 'Day : DD-Mon-YYYY') B ,
	count(*) C
from v$log_history
where trunc(first_time) > last_day(sysdate-100) +1
group by trunc(first_time)
/

Prompt BLOCKS in Wait (at moment):
select
   p1 "File #",
   p2 "Block #",
   p3 "Reason Code"
from
   v$session_wait
where
   event = 'buffer busy waits'
/   

Prompt BLOCKS in Wait (statistics):
set lines 250
Select * from (
select
   owner,object_name,
   statistic_name,
   value
from
   V$SEGMENT_STATISTICS
where
     statistic_name='buffer busy waits'
order by 4 desc) where rownum<6
/


set lines 250

col name format a65
col readtim/phyrds heading 'avg|read time' format 9,999.999
col writetim/phywrts heading 'avg|write time' format 9,999.999
set lines 132 
set feed off 

prompt IO timing analysis - data files
select  f.file#
,d.name,phyrds,phywrts,readtim/phyrds,writetim/phywrts
from v$filestat f, v$datafile d
where f.file#=d.file#
and phyrds>0 and phywrts>0
and rownum<6
order by 5 desc
/

prompt IO timing analysis - temp files
select  a.file#
,b.name,phyrds,phywrts,readtim/phyrds,writetim/phywrts
from v$tempstat a, v$tempfile b
where a.file#=b.file#
and phyrds>0 and phywrts>0
and rownum<6
order by 5 desc
/

Prompt Sessions waits, group by event:
select
   event,
   count(*) qtd
from
   v$session_wait
group by
   event
order by 
      2 desc
/   

column redundant_index format a39
column sufficient_index format a39

Prompt Redudant indexes:

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
  o1.name not in ('SYS','SYSTEM','DAA') and
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
/


 
spool off


spool c:\temp\health2_&Instancia..txt
set echo off  
set feedback off 
  
prompt**************************************************** 
prompt Hit Ratio Section  
prompt**************************************************** 
prompt  
prompt  =========================  
prompt  BUFFER HIT RATIO  
prompt  =========================  
prompt (should be > 70, else increase db_block_buffers in init.ora)  
  
select trunc((1-(sum(decode(name,'physical reads',value,0))/  
             (sum(decode(name,'db block gets', value,0))+ 
    (sum(decode(name,'consistent gets',value,0)))))  
              )* 100) "Buffer Hit Ratio"  
 from v$sysstat;  
  
column "logical_reads" format 99,999,999,999  
column "phys_reads" format 999,999,999  
column "phy_writes" format 999,999,999  
select a.value + b.value "logical_reads",  
                c.value   "phys_reads",  
                d.value   "phy_writes",  
                round(100 * ((a.value+b.value)-c.value) /                
(a.value+b.value))  
                "BUFFER HIT RATIO"  
from v$sysstat a, v$sysstat b, v$sysstat c, v$sysstat d  
where  
        a.name = 'db block gets'  
and  
        b.name = 'consistent gets'  
and  
        c.name = 'physical reads'
and  
        d.name = 'physical writes';  
  
prompt  
prompt  
prompt  =========================  
prompt  DATA DICT HIT RATIO  
prompt  =========================  
prompt (should be higher than 90 else increase shared_pool_size in init.ora)  
prompt  
  
column "Data Dict. Gets"   format 999,999,999  
column "Data Dict. cache misses" format 999,999,999  
select sum(gets) "Data Dict. Gets",  
      sum(getmisses) "Data Dict. cache misses",  
      trunc((1-(sum(getmisses)/sum(gets)))*100)  
      "DATA DICT CACHE HIT RATIO"  
from v$rowcache;  
 
prompt  
prompt  =========================  
prompt  LIBRARY CACHE MISS RATIO  
prompt  =========================  
prompt (If > .1, i.e., more than 1% of the pins resulted in reloads, then  
prompt increase the shared_pool_size in init.ora)  
prompt  
column "LIBRARY CACHE MISS RATIO" format 99.9999  
column "executions" format 999,999,999  
column "Cache misses while executing" format 999,999,999  
select sum(pins) "executions", sum(reloads) "Cache misses while executing",  
                (((sum(reloads)/sum(pins)))) "LIBRARY CACHE MISS RATIO"  
from v$librarycache;  
  
prompt  
prompt  =========================  
prompt  Library Cache Section  
prompt  =========================  
prompt hit ratio should be > 70, and pin ratio > 70 ...  
prompt  
  
column "reloads" format 999,999,999  
select namespace, trunc(gethitratio * 100) "Hit ratio",  
trunc(pinhitratio * 100) "pin hit ratio", reloads "reloads"  
from v$librarycache;  
prompt  
prompt  
prompt  =========================  
prompt  REDO LOG BUFFER  
prompt  =========================  
prompt  
set heading off  
column value format 999,999,999  
select substr(name,1,30),  
                value  
from v$sysstat where name = 'redo log space requests';  
  
set heading on  
prompt ****************************************************
prompt Pool's Free Memory
prompt ****************************************************
  
column bytes format 999,999,999,999  
select pool,name, bytes from v$sgastat where name = 'free memory'; 
  
prompt  
prompt****************************************************  
prompt SQL Summary Section  
prompt****************************************************  
prompt  
column "Tot SQL run since startup" format 999,999,999  
column "SQL executing now"  format 999,999,999  
select sum(executions) "Tot SQL run since startup",  
                sum(users_executing) "SQL executing now"  
                from v$sqlarea;  
  
prompt  
prompt  
prompt****************************************************  
prompt Lock Section  
prompt****************************************************  
prompt  
prompt  =========================  
prompt SYSTEM-WIDE LOCKS - all requests for locks or latches  
prompt  =========================  
prompt 
prompt Processing Locks and Latches, please standby...
 
select /*+ ordered */ substr(username,1,12) "User",  
          substr(lock_type,1,18) "Lock Type",  
                substr(mode_held,1,18) "Mode Held"  
        from v$session b ,sys.dba_lock a
        where lock_type not in ('Media Recovery','Redo Thread')  
        and a.session_id = b.sid;  
prompt  
prompt  =========================  
prompt DDL LOCKS - These are usually triggers or other DDL  
prompt  =========================  
prompt  
select substr(username,1,12) "User",  
                substr(owner,1,8) "Owner",  
     substr(name,1,15) "Name",  
                substr(a.type,1,20) "Type",  
             substr(mode_held,1,11) "Mode held"  
from sys.dba_ddl_locks a, v$session b  
        where a.session_id = b.sid;  
  
prompt  
prompt  =========================  
prompt  DML LOCKS - These are table and row locks...  
prompt  =========================  
prompt  
select substr(username,1,12) "User",  
 substr(owner,1,8) "Owner",  
                substr(name,1,20) "Name",  
        substr(mode_held,1,21) "Mode held"  
from sys.dba_dml_locks a, v$session b  
        where a.session_id = b.sid;  
  
prompt  
prompt  
prompt****************************************************  
prompt Latch Section  
prompt****************************************************  
prompt if miss_ratio or immediate_miss_ratio > 1 then latch  
prompt contention exists, decrease LOG_SMALL_ENTRY_MAX_SIZE in init.ora  
prompt  
column "miss_ratio" format 999.99  
column "immediate_miss_ratio" format 999.99  
select substr(l.name,1,30) name,  
        (misses/(gets+.001))*100 "miss_ratio",  
        (immediate_misses/(immediate_gets+.001))*100  
        "immediate_miss_ratio"  
        from v$latch l, v$latchname ln  
where l.latch# = ln.latch#  
        and (  
        (misses/(gets+.001))*100 > .2  
or  
        (immediate_misses/(immediate_gets+.001))*100 > .2  
)  
order by l.name;  
  
prompt  
prompt  
prompt****************************************************  
prompt Rollback Segment Section  
prompt****************************************************  
prompt if any count below is > 1% of the total number of requests for data  
prompt then more rollback segments are needed  
 
 --column count format 999,999,999  
select class, count  
        from v$waitstat  
where class in ('free list','system undo header','system undo block',  
                        'undo header','undo block')  
group by class,count;  
  
column "Tot # of Requests for Data" format 999,999,999  
 
select sum(value) "Tot # of Requests for Data" from v$sysstat where  
name in ('db block gets', 'consistent gets');  
 
 
prompt  
prompt  =========================  
prompt  ROLLBACK SEGMENT CONTENTION  
prompt  =========================  
prompt  
prompt   If any ratio is > .01 then more rollback segments are needed  
  
column "Ratio" format 99.99999  
select name, waits, gets, waits/gets "Ratio"  
        from v$rollstat a, v$rollname b  
where a.usn = b.usn;  
  
column "total_waits" format 999,999,999  
column "total_timeouts" format 999,999,999  
prompt  
prompt  
set feedback on;  
prompt****************************************************  
prompt Session Event Section  
prompt****************************************************  
prompt if average-wait > 20 then contention might exists  
prompt  
        select substr(event,1,30) event,  
                total_waits, total_timeouts, average_wait  
 from v$session_event  
where average_wait > 0 
and sid not in (select s.sid from v$session s
            where s.paddr in (select p.addr from v$process p
                              where p.background='1'))
and event not like '%SQL%from%'
and event not like '%rdbms%'
and event not like '%wake%'
/  

prompt  
prompt  
prompt****************************************************  
prompt Queue Section  
prompt****************************************************  
prompt average wait for queues should be near zero ...  
prompt  
column "totalq" format 999,999,999  
column "# queued" format 999,999,999  
select paddr, type "Queue type", queued "# queued", wait, totalq,  
decode(totalq,0,0,wait/totalq) "AVG WAIT" from v$queue;  
  
set feedback on;  
prompt  
prompt  
prompt****************************************************  
prompt Multi-threaded Server Section  
prompt****************************************************  
prompt  
prompt If the following number is > 1  
prompt then increase MTS_MAX_SERVERS parm in init.ora  
prompt  
 select decode( totalq, 0, 'No Requests',  
    wait/totalq || ' hundredths of seconds')  
    "Avg wait per request queue"  
 from v$queue  
 where type = 'COMMON';  

set feedback off

prompt  
prompt If the following number increases, consider adding dispatcher processes 
prompt   
prompt  
 select decode( sum(totalq), 0, 'No Responses',  
      sum(wait)/sum(totalq) || ' hundredths of seconds')  
              "Avg wait per response queue"  
 from v$queue q, v$dispatcher d  
 where q.type = 'DISPATCHER'  
      and q.paddr = d.paddr;  
  
   
prompt  
prompt  
prompt        =========================  
prompt        DISPATCHER USAGE  
prompt        =========================  
prompt (If Time Busy > 50, then change 
prompt        MTS_MAX_DISPATCHERS in init.ora)  
column "Time Busy" format 999,999.999  
column busy  format 999,999,999  
column idle  format 999,999,999  
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
  
 prompt  
 prompt****************************************************  
 prompt file i/o should be evenly distributed across drives.  
 prompt  
  
select  
substr(a.file#,1,2) "#",  
substr(a.name,1,30) "Name",  
a.status,  
a.bytes,  
b.phyrds,  
b.phywrts  
from v$datafile a, v$filestat b  
where a.file# = b.file#;  

column value format 999,999,999,999  
select substr(name,1,55) system_statistic, value  
 from v$sysstat  
 order by name;  
 spool off
 
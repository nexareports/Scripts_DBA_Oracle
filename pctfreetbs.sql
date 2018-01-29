--set lines 250
--set pages 1000
--set feed off

col graph for a24
select total.ts tablespace,
 DECODE(total.mb,null,'OFFLINE',dbat.status) status,
 total.mb total_mb,
 NVL(total.mb - free.mb,total.mb) used_mb,
 NVL(free.mb,0) free_mb,
 DECODE(total.mb,NULL,0,NVL(ROUND((total.mb - free.mb)/(total.mb)*100,2),100)) pct_used,
 CASE WHEN (total.mb IS NULL) THEN '['||RPAD(LPAD('OFFLINE',13,'-'),20,'-')||']'
 ELSE '['|| DECODE(free.mb,
 null,'XXXXXXXXXXXXXXXXXXXX',
 NVL(RPAD(LPAD('X',trunc((100-ROUND( (free.mb)/(total.mb) * 100, 2))/5),'X'),20,'-'),
 '--------------------'))||']'
 END as GRAPH
from
 (select tablespace_name ts, sum(bytes)/1024/1024 mb from dba_data_files group by tablespace_name) total,
 (select tablespace_name ts, sum(bytes)/1024/1024 mb from dba_free_space group by tablespace_name) free,
 dba_tablespaces dbat
where total.ts=free.ts(+) and
 total.ts=dbat.tablespace_name
UNION ALL
select sh.tablespace_name,
 'TEMP',
 SUM(sh.bytes_used+sh.bytes_free)/1024/1024 total_mb,
 SUM(sh.bytes_used)/1024/1024 used_mb,
 SUM(sh.bytes_free)/1024/1024 free_mb,
 ROUND(SUM(sh.bytes_used)/SUM(sh.bytes_used+sh.bytes_free)*100,2) pct_used,
 '['||DECODE(SUM(sh.bytes_free),0,'XXXXXXXXXXXXXXXXXXXX',
 NVL(RPAD(LPAD('X',(TRUNC(ROUND((SUM(sh.bytes_used)/SUM(sh.bytes_used+sh.bytes_free))*100,2)/5)),'X'),20,'-'),
 '--------------------'))||']'
FROM v$temp_space_header sh
GROUP BY tablespace_name
order by 6 desc
/


col graph clear
Prompt @tbs 

--set feed on


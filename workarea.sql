
col sid format a10
SELECT to_char(to_number(decode(a.SID, 65535, NULL, a.SID))) sid,
       operation_type OPERATION,
       trunc(a.EXPECTED_SIZE/1024) ESIZE,
       trunc(a.ACTUAL_MEM_USED/1024) MEM,
       trunc(a.MAX_MEM_USED/1024) "MAX MEM",
       a.NUMBER_PASSES PASS,
       trunc(a.TEMPSEG_SIZE/1024) TSIZE,
       b.sql_hash_value
  FROM V$SQL_WORKAREA_ACTIVE a, v$session b
  where a.sid=b.sid
 ORDER BY 5 desc,1,2
 /
 
SELECT round(PGA_TARGET_FOR_ESTIMATE/1024/1024) target_mb,
       ESTD_PGA_CACHE_HIT_PERCENTAGE cache_hit_perc,
       ESTD_OVERALLOC_COUNT
FROM   v$pga_target_advice;

 
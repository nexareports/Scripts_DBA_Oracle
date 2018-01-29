--set SERVEROUTPUT ON
--set LINESIZE 1000
--set FEEDBACK OFF

SELECT *
FROM   v$database;
PROMPT

DECLARE
  v_value  NUMBER;

  FUNCTION Format(p_value  IN  NUMBER) 
    RETURN VARCHAR2 IS
  BEGIN
    RETURN LPad(To_Char(Round(p_value,2),'990.00') || '%',8,' ') || '  ';
  END;

BEGIN

  -- --------------------------
  -- Dictionary Cache Hit Ratio
  -- --------------------------
  SELECT (1 - (Sum(getmisses)/(Sum(gets) + Sum(getmisses)))) * 100
  INTO   v_value
  FROM   v$rowcache;

  DBMS_Output.Put('Dictionary Cache Hit Ratio       : ' || Format(v_value));
  IF v_value < 90 THEN
    DBMS_Output.Put_Line('Increase SHARED_POOL_SIZE parameter to bring value above 90%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;

  -- -----------------------
  -- Library Cache Hit Ratio
  -- -----------------------
  SELECT (1 -(Sum(reloads)/(Sum(pins) + Sum(reloads)))) * 100
  INTO   v_value
  FROM   v$librarycache;

  DBMS_Output.Put('Library Cache Hit Ratio          : ' || Format(v_value));
  IF v_value < 99 THEN
    DBMS_Output.Put_Line('Increase SHARED_POOL_SIZE parameter to bring value above 99%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;

  -- -------------------------------
  -- DB Block Buffer Cache Hit Ratio
  -- -------------------------------
  SELECT (1 - (phys.value / (db.value + cons.value))) * 100
  INTO   v_value
  FROM   v$sysstat phys,
         v$sysstat db,
         v$sysstat cons
  WHERE  phys.name  = 'physical reads'
  AND    db.name    = 'db block gets'
  AND    cons.name  = 'consistent gets';

  DBMS_Output.Put('DB Block Buffer Cache Hit Ratio  : ' || Format(v_value));
  IF v_value < 89 THEN
    DBMS_Output.Put_Line('Increase DB_BLOCK_BUFFERS parameter to bring value above 89%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;
  
  -- ---------------
  -- Latch Hit Ratio
  -- ---------------
  SELECT (1 - (Sum(misses) / Sum(gets))) * 100
  INTO   v_value
  FROM   v$latch;

  DBMS_Output.Put('Latch Hit Ratio                  : ' || Format(v_value));
  IF v_value < 98 THEN
    DBMS_Output.Put_Line('Increase number of latches to bring the value above 98%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;

  -- -----------------------
  -- Disk Sort Ratio
  -- -----------------------
  SELECT (disk.value/mem.value) * 100
  INTO   v_value
  FROM   v$sysstat disk,
         v$sysstat mem
  WHERE  disk.name = 'sorts (disk)'
  AND    mem.name  = 'sorts (memory)';

  DBMS_Output.Put('Disk Sort Ratio                  : ' || Format(v_value));
  IF v_value > 5 THEN
    DBMS_Output.Put_Line('Increase SORT_AREA_SIZE parameter to bring value below 5%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;
  
  -- ----------------------
  -- Rollback Segment Waits
  -- ----------------------
  SELECT (Sum(waits) / Sum(gets)) * 100
  INTO   v_value
  FROM   v$rollstat;

  DBMS_Output.Put('Rollback Segment Waits           : ' || Format(v_value));
  IF v_value > 5 THEN
    DBMS_Output.Put_Line('Increase number of Rollback Segments to bring the value below 5%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;

  -- -------------------
  -- Dispatcher Workload
  -- -------------------
  SELECT NVL((Sum(busy) / (Sum(busy) + Sum(idle))) * 100,0)
  INTO   v_value
  FROM   v$dispatcher;

  DBMS_Output.Put('Dispatcher Workload              : ' || Format(v_value));
  IF v_value > 50 THEN
    DBMS_Output.Put_Line('Increase MTS_DISPATCHERS to bring the value below 50%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;
  
END;
/

PROMPT
--set FEEDBACK ON


--set lines 250
--set pages 1000
--set feedback off
-- Default, Keep, and Recycle Pools
COL pool FORMAT a10;
SELECT a.name "Pool", a.physical_reads, a.db_block_gets
      , a.consistent_gets
,(SELECT ROUND(
(1-(physical_reads/(db_block_gets + consistent_gets)))*100)
      FROM v$buffer_pool_statistics
      WHERE db_block_gets+consistent_gets ! = 0
      AND name = a.name) "Ratio"
FROM v$buffer_pool_statistics a;


-- Tabelas
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

-- Index
SELECT value, name FROM V$SYSSTAT WHERE name IN
      ('table fetch by rowid', 'table scans 
         (short tables)', 'table scans (long tables)')
OR name LIKE 'index fast full%' OR name = 'index fetch by
   key';

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
FROM DUAL;

-- Dictionary
SELECT 'Dictionary Cache Hit Ratio ' "Ratio"
,ROUND((1 - (SUM(GETMISSES)/SUM(GETS))) * 100,2)||'%' 
   "Percentage"
FROM V$ROWCACHE;


--Library Cache Hit Ratios
SELECT 'Library Lock Requests' "Ratio"
 , ROUND(AVG(gethitratio) * 100, 2)
      ||'%' "Percentage" FROM V$LIBRARYCACHE
UNION
SELECT 'Library Pin Requests' "Ratio", ROUND(AVG
   (pinhitratio) * 100, 2)
       ||'%' "Percentage" FROM V$LIBRARYCACHE
UNION
SELECT 'Library I/O Reloads' "Ratio"
      , ROUND((SUM(reloads) / SUM(pins)) * 100, 2)
      ||'%' "Percentage" FROM V$LIBRARYCACHE
UNION
SELECT 'Library Reparses' "Ratio"
      , ROUND((SUM(reloads) / SUM(pins)) * 100, 2)
      ||'%' "Percentage" FROM V$LIBRARYCACHE;


--Disk
SELECT 'Sorts in Memory ' "Ratio"
, ROUND(
  (SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'sorts 
    (memory)')
/ (SELECT SUM(value) FROM V$SYSSTAT
    WHERE name IN ('sorts (memory)', 'sorts (disk)')) *
      100, 2)
||'%' "Percentage"
FROM DUAL;

--Chained Ratios

SELECT 'Chained Rows ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
WHERE name = 'table fetch continued row')
/ (SELECT SUM(value) FROM V$SYSSTAT
   WHERE name IN ('table scan rows gotten', 'table fetch
      by rowid'))
* 100, 3)||'%' "Percentage"
FROM DUAL;
   

--Parse Ratio

SELECT 'Soft Parses ' "Ratio"
, ROUND(
((SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'parse 
   count (total)')
- (SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'parse 
   count (hard)'))
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'execute 
   count')
* 100, 2)||'%' "Percentage"
FROM DUAL
UNION
SELECT 'Hard Parses ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'parse count 
   (hard)')
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'execute 
   count')
* 100, 2)||'%' "Percentage"
FROM DUAL
UNION
SELECT 'Parse Failures ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
 WHERE name = 'parse count (failures)')
/ (SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'parse 
    count (total)')
* 100, 2)||'%' "Percentage"
   FROM DUAL;

--Latch Ratio

SELECT 'Latch Hit Ratio ' "Ratio"
, ROUND(
(SELECT SUM(gets) - SUM(misses) FROM V$LATCH)
/ (SELECT SUM(gets) FROM V$LATCH)
* 100, 2)||'%' "Percentage"
FROM DUAL;
   

SELECT a.namespace "Name Space",
       a.gets "Get Requests",
       a.gethits "Get Hits",
       Round(a.gethitratio,2) "Get Ratio",
       a.pins "Pin Requests",
       a.pinhits "Pin Hits",
       Round(a.pinhitratio,2) "Pin Ratio",
       a.reloads "Reloads",
       a.invalidations "Invalidations"
FROM   v$librarycache a
ORDER BY 1;

@CursorEfficiency
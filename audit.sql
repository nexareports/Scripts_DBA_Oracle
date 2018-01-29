set serveroutput on
set lines 250
set pages 1000
spool c:\tmp\&1

set head off
select 	'========================================================='||chr(10)||
	'INICIO DA AUDITORIA:'||to_char(sysdate,'dd-mm-yyy hh24:mi')||chr(10)||
	'========================================================='
from dual
/
set head off

set feedback off
set serveroutput on
exec dbms_output.put_line('===================================================================');
select 'BD: '||instance_name from v$instance;
exec dbms_output.put_line('===================================================================');
show user
exec dbms_output.put_line('===================================================================');
select 'Data: '||to_char(sysdate,'DD/MM/YYYY HH24:MI:SS') from dual;
exec dbms_output.put_line('===================================================================');
exec dbms_output.put_line('Dados da instância:');
select * from v$version;
exec dbms_output.put_line('===================================================================');


set serveroutput on
set lines 250
set pages 1000

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Security related database initialization parameters and password file users.'||chr(10)||
	'========================================================================================='
from dual
/
set head on


select name || '=' || value "PARAMTER"
from   sys.v_$parameter 
where  name in ('remote_login_passwordfile', 'remote_os_authent', 
                'os_authent_prefix', 'dblink_encrypt_login',
                'audit_trail', 'transaction_auditing')
/


select * from sys.v_$pwfile_users
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Different parameters of default.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

COLUMN name          FORMAT A30
COLUMN current_value FORMAT A30
COLUMN sid           FORMAT A8
COLUMN spfile_value  FORMAT A30

SELECT p.name,
       i.instance_name AS sid,
       p.value AS current_value,
       sp.sid,
       sp.value AS spfile_value      
FROM   v$spparameter sp,
       v$parameter p,
       v$instance i
WHERE  sp.name   = p.name
AND    sp.value != p.value
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    List security related profile information.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

Select	owner,trigger_name,BASE_OBJECT_TYPE from dba_triggers where BASE_OBJECT_TYPE like '%DATABASE%'
/


set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    List security related profile information.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

col profile format a20 
col limit   format a20

select profile, resource_name, limit 
from   dba_profiles
where  resource_name like '%PASSWORD%' 
   or  resource_name like '%LOGIN%'
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Which users have been granted privileges to audit the database.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

col grantee for a20
col privilege for a15
col admin_option for a4
select grantee,privilege,admin_option
from dba_sys_privs
where privilege like '%AUDIT%'
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Database users with deadly roles assigned to them.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

select grantee, granted_role, admin_option
from   sys.dba_role_privs 
where  granted_role in ('DBA', 'AQ_ADMINISTRATOR_ROLE',
                       'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE',
                       'OEM_MONITOR')
  and  grantee not in ('SYS', 'SYSTEM', 'OUTLN', 'AQ_ADMINISTRATOR_ROLE',
                       'DBA', 'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE',
                       'OEM_MONITOR', 'CTXSYS', 'DBSNMP', 'IFSSYS',
                       'IFSSYS$CM', 'MDSYS', 'ORDPLUGINS', 'ORDSYS',
                       'TIMESERIES_DBA')
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Database users with deadly system privilages assigned to them.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

select grantee, privilege, admin_option
from   sys.dba_sys_privs 
where  (privilege like '% ANY %'
  or   privilege in ('BECOME USER', 'UNLIMITED TABLESPACE')
  or   admin_option = 'YES')
 and   grantee not in ('SYS', 'SYSTEM', 'OUTLN', 'AQ_ADMINISTRATOR_ROLE',
                       'DBA', 'EXP_FULL_DATABASE', 'IMP_FULL_DATABASE',
                       'OEM_MONITOR', 'CTXSYS', 'DBSNMP', 'IFSSYS',
                       'IFSSYS$CM', 'MDSYS', 'ORDPLUGINS', 'ORDSYS',
                       'TIMESERIES_DBA')
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    System privileges granted to users and roles.'||chr(10)||
	'========================================================================================='
from dual
/
set head on


set lines 250
set pages 1000
col GRANTEE format a30
col ADMIN_OPTION format a15
col PRIVILEGE format a50
Select grantee,privilege,admin_option from dba_sys_privs
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    System privileges granted to users and roles.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

set lines 250
set pages 10000
col GRANTEE format a30
col owner format a15
col PRIVILEGE format a50
select grantee,owner,privilege from DBA_TAB_PRIVS
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Invalid objects total for schema.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

col owner format a10
col object_type format a20
col Qtd format a5
select owner,object_type,count(*) Qtd
from dba_objects where status='INVALID'
group by owner,object_type
order by owner,object_type
/


set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Invalid objects for schema.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

col owner format a10
col object_type format a20
col object_name format a30
select owner,object_type,object_name,last_ddl_time
from dba_objects
where status='INVALID'
order by 1,2,3
/

set head off
set feed off
select 	'========================================================================================='||chr(10)||
	'Purpose:    Ratios.'||chr(10)||
	'========================================================================================='
from dual
/
set head on

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

dbms_output.put_line('-- --------------------------');
  SELECT (1 - (Sum(getmisses)/(Sum(gets) + Sum(getmisses)))) * 100
  INTO   v_value
  FROM   v$rowcache;

  DBMS_Output.Put('Dictionary Cache Hit Ratio       : ' || Format(v_value));
  IF v_value < 90 THEN
    DBMS_Output.Put_Line('Increase SHARED_POOL_SIZE parameter to bring value above 90%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;

 dbms_output.put_line('-- -----------------------');
  SELECT (1 -(Sum(reloads)/(Sum(pins) + Sum(reloads)))) * 100
  INTO   v_value
  FROM   v$librarycache;

  DBMS_Output.Put('Library Cache Hit Ratio          : ' || Format(v_value));
  IF v_value < 99 THEN
    DBMS_Output.Put_Line('Increase SHARED_POOL_SIZE parameter to bring value above 99%');
  ELSE
    DBMS_Output.Put_Line('Value Acceptable.');  
  END IF;

  dbms_output.put_line('-- -------------------------------');
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
  
  dbms_output.put_line('-- ---------------');
  SELECT (1 - (Sum(misses) / Sum(gets))) * 100
  INTO   v_value
  FROM   v$latch;

  DBMS_Output.Put('Latch Hit Ratio                  : ' || Format(v_value));
  IF v_value < 98 THEN
    DBMS_Output.Put_Line('Increase number of latches to bring the value above 98%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;

  dbms_output.put_line('-- -----------------------');
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
  
  dbms_output.put_line('-- ----------------------');
  SELECT (Sum(waits) / Sum(gets)) * 100
  INTO   v_value
  FROM   v$rollstat;

  DBMS_Output.Put('Rollback Segment Waits           : ' || Format(v_value));
  IF v_value > 5 THEN
    DBMS_Output.Put_Line('Increase number of Rollback Segments to bring the value below 5%');
  ELSE
    DBMS_Output.Put_Line('Value acceptable.');
  END IF;

  dbms_output.put_line('-- -------------------');
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


exec dbms_output.put_line('-- Default, Keep, and Recycle Pools');
COL pool FORMAT a10;
SELECT a.name "Pool", a.physical_reads, a.db_block_gets
      , a.consistent_gets
,(SELECT ROUND(
(1-(physical_reads/(db_block_gets + consistent_gets)))*100)
      FROM v$buffer_pool_statistics
      WHERE db_block_gets+consistent_gets ! = 0
      AND name = a.name) "Ratio"
FROM v$buffer_pool_statistics a;


exec dbms_output.put_line('-- Tabelas');
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

exec dbms_output.put_line('--Chained Ratios');

SELECT 'Chained Rows ' "Ratio"
, ROUND(
(SELECT SUM(value) FROM V$SYSSTAT
WHERE name = 'table fetch continued row')
/ (SELECT SUM(value) FROM V$SYSSTAT
   WHERE name IN ('table scan rows gotten', 'table fetch
      by rowid'))
* 100, 3)||'%' "Percentage"
FROM DUAL;
   

exec dbms_output.put_line('--Parse Ratio');

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

exec dbms_output.put_line('--Latch Ratio');

SELECT 'Latch Hit Ratio ' "Ratio"
, ROUND(
(SELECT SUM(gets) - SUM(misses) FROM V$LATCH)
/ (SELECT SUM(gets) FROM V$LATCH)
* 100, 2)||'%' "Percentage"
FROM DUAL;
   

spoo off

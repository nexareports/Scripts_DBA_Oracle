--set lines 250
--set pages 1000
-- SET echo off
-- SET feedback off
-- SET term off
-- SET pagesize 0
-- SET linesize 200
-- SET newpage 0
-- SET space 0
-- set trimspool on
-- set timming off

Select 
'alter session set db_file_multiblock_read_count=512;'||chr(10) CMD
from dual
union all
Select 
'alter index '||owner||'.'||index_name||' rebuild tablespace '||tablespace_name||'_REORG nologging;' CMD
from dba_indexes
where status='UNUSABLE'
union all
Select CMD from (
select 
'alter index '||index_owner||'.'||index_name||' rebuild partition '||partition_name||' tablespace '||tablespace_name||'_REORG;' CMD
from dba_ind_partitions where status='UNUSABLE' order by index_name,partition_name desc)
/


--set lines 250
--set pages 1000

Select 
'alter session set db_file_multiblock_read_count=512;'||chr(10) CMD
from dual
union all
Select 
'alter index '||owner||'.'||index_name||' rebuild tablespace '||tablespace_name||'_REORG nologging;' CMD
from dba_indexes
where tablespace_name not like '%_REORG' and tablespace_name not in ('SYSTEM','SYSAUX','TEMP','UNDOTBS1','UNDOTBS2')
union all
Select CMD from (
select 
'alter index '||index_owner||'.'||index_name||' rebuild partition '||partition_name||' tablespace '||tablespace_name||'_REORG;' CMD
from dba_ind_partitions where tablespace_name not like '%_REORG' and tablespace_name not in ('SYSTEM','SYSAUX','TEMP','UNDOTBS1','UNDOTBS2') order by index_name,partition_name desc)
/


--set lines 250
--set pages 1000

Select 
'alter session set db_file_multiblock_read_count=512;'||chr(10) CMD
from dual
union all
Select 
'alter index '||owner||'.'||index_name||' rebuild tablespace '||replace(tablespace_name,'_OLD','')||' nologging;' CMD
from dba_indexes
where tablespace_name like '%_OLD'
union all
Select CMD from (
select 
'alter index '||index_owner||'.'||index_name||' rebuild partition '||partition_name||' tablespace '||replace(tablespace_name,'_OLD','')||';' CMD
from dba_ind_partitions where tablespace_name like '%_OLD' 
order by index_owner,index_name,partition_name desc)
/


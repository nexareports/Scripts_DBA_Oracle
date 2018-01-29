select TABLESPACE_NAME, segment_name,sum(blocks) "TOTAL BLOCKS", round(sum(bytes)/1024/1024,2) MB
from DBA_UNDO_EXTENTS
group by TABLESPACE_NAME, segment_name
order by 1, 2
/

select inst_id, to_char(begin_time,'dd-mon hh24:mi:ss') begin_time, to_char(end_time,'dd-monhh24:mi:ss') end_time, undoblks
from gv$undostat a
where END_TIME = (select max(END_TIME) from gv$undostat b where b.inst_id=a.inst_id)
/

col status for a10
select tablespace_name, status, round(sum(bytes)/1024/1024,2) "MBYTES"
from dba_undo_extents
where tablespace_name in (select value from gv$parameter where name='undo_tablespace')
group by tablespace_name, status
/

select count(1) OFFLINE#
from dba_rollback_segs
where status='OFFLINE'
/
 
select tablespace_name, round(sum(bytes)/1024/1024,2) SIZE_MB
from dba_data_files
where tablespace_name in ( 
	select distinct tablespace_name
	from dba_rollback_segs 
	where tablespace_name <> 'SYSTEM' 
	)
group by tablespace_name
/

select tablespace_name, round(sum(bytes)/1024/1024,2) FREE_MB
from dba_free_space
where tablespace_name in ( 
	select distinct tablespace_name
	from dba_rollback_segs 
	where tablespace_name <> 'SYSTEM' 
	)
group by tablespace_name
/

select tablespace_name, file_name, round(bytes/1024/1024,2) MB, autoextensible 
from dba_data_files
where tablespace_name in (
	select distinct tablespace_name
	from dba_rollback_segs 
	where tablespace_name <> 'SYSTEM' 
)
/

col value format a35

select inst_id, name, value 
from gv$parameter
where name like '%undo%'
/

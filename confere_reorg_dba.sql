set echo off
set pages 10000
set verify off
set termout off
col segment_name for a40
col object_name for a40
set lines 160

--Analiza estado objecto antes e depois de usar o livereorg

spo off
-- EFECTUA LOG
column fich_log new_value logs

select 'C:\Logs\MOVE_TABLE_'||to_char(sysdate,'yyyymmdd_hh24miss')||'.log' fich_log 
from dual;
spo &logs


define conj= CC_CADASTRO','LOGON_SINTRA

prompt CONTAGEM DE OBJECTOS POR USER

select owner, OBJECT_TYPE, count(1) count
                from dba_objects                                                     
                group by owner, OBJECT_TYPE
                order by owner, OBJECT_TYPE;


prompt ESPAÇO TABELAS    
            
select owner, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME,EXTENTS,sum(BYTES/1024/1024)MB
from dba_segments
where --EXTENTS = '1'
segment_name in ('&conj')
--and TABLESPACE_NAME = 'D4SINGL'
group by  owner, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, EXTENTS
order by 1, 2;


prompt ESPAÇO INDICES

select owner, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME,EXTENTS,sum(BYTES/1024/1024)MB
from dba_segments
where segment_name in (select index_name from dba_indexes where table_name in ('&conj'))
group by  owner, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, EXTENTS
order by 1,2;

prompt ESPAÇO TABLESPACES

SET PAGES 40 LINES 300;
SELECT Substr(df.tablespace_name,1,20) tablespace,
       Round(sum(df.bytes/1024/1024),2) Total,
       Round(sum(f.free_bytes/1024/1024),2) Free
FROM   sys.DBA_DATA_FILES DF,
         (SELECT sum(bytes) free_bytes,file_id FROM SYS.dba_free_space GROUP BY file_id) f
WHERE  df.file_id  = f.file_id (+)
and df.tablespace_name in (SELECT TABLESPACE_NAME FROM DBA_TABLESPACES)
group by df.tablespace_name
ORDER BY df.tablespace_name;

prompt OBJECTOS INVÁLIDOS

select owner, OBJECT_NAME, OBJECT_ID,
         OBJECT_TYPE, CREATED, 
      LAST_DDL_TIME, TIMESTAMP
from dba_objects where status!='VALID';

prompt CONSTRAINTS DISABLE

select OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME,STATUS, count (*) count
from dba_constraints
where STATUS != 'ENABLED'
group by OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME,STATUS
order by OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME,STATUS;

prompt INDICES UNUSABLE

select owner, INDEX_NAME, INDEX_TYPE, TABLE_NAME,TABLESPACE_NAME, STATUS, count (*) count
from dba_indexes
where STATUS != 'VALID'
group by owner, INDEX_NAME, INDEX_TYPE, TABLE_NAME,TABLESPACE_NAME, STATUS
order by 1,2;

prompt TRIGGERS DISABLE

col TRIGGERING_EVENT for a25
col COLUMN_NAME for a25

select owner, TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT,
       TABLE_OWNER, TABLE_NAME,COLUMN_NAME,
       ACTION_TYPE, STATUS, count (*) count
from dba_triggers
where --TABLE_OWNER = 'ESINGLRP'and 
STATUS != 'ENABLED'
group by owner, TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT,
       TABLE_OWNER, TABLE_NAME,COLUMN_NAME,
       ACTION_TYPE, STATUS
order by 1,2; 

undefine logs

spo off
set termout on

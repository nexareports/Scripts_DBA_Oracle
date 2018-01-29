col FILE_NAME for a70
select file_id, FILE_NAME, bytes/1048576 Mb
from dba_data_files
where tablespace_name='&1'
/



select 'ALTER DATABASE DATAFILE '||file_id||' RESIZE '|| decode(bytes,30000000000,round((bytes/1048576)*1.3),32767) ||'M;' "RESIZE DATAFILES" from dba_data_files
where tablespace_name='&1'
/

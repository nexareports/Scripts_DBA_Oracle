col file_name for a60
col tablespace_name for a20
select file_id, file_name, tablespace_name, round(bytes/1048576) MB, status, autoextensible from dba_temp_files order by file_id;
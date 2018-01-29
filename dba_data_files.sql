col file_name for a60
col tablespace_name for a20
select file_id, file_name, tablespace_name, round(bytes/1048576) MB, status, autoextensible, online_status from dba_data_files order by file_id;
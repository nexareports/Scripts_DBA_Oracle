col owner for a15
col directory_name for a30
col directory_path for a70
select * from dba_directories where owner like upper('%&1%');
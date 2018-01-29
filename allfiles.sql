--set lines 250
--set pages 1000
col tipo format a11
col ficheiro format a100
Select Tipo,Size_in_MB,Ficheiro from (
select  'Datafile'	Tipo,
	file_name	Ficheiro,
	bytes/1024/1024 Size_in_MB
from 	dba_data_files
union all
select  'Tempfile'	Tipo,
	file_name	Ficheiro,
	bytes/1024/1024 Size_in_MB
from 	dba_temp_files
union all
select  'Controlfile'	Tipo,
	name		Ficheiro,
	15		Size_in_MB
from	v$controlfile
union all
select  'Redolog'	Tipo,
	a.member		Ficheiro,
	b.bytes/1024/1024	Size_in_MB
from	v$logfile a,v$log b where a.group#=b.group#)
order by 1,3,2 desc;

--set feed off
select round(sum(bytes)/1024/1024) DataFiles_Mb from dba_data_files;
--set feed on

@__conf
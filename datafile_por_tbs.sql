--set lines 250
--set pages 1000
--set feed off

Select 
	substr(file_name,1,6) 				Nome,
	bytes/1024/1024					"Size Mb",
	'alter database datafile '||file_id||' resize' 	CMD
From
	dba_data_files
Where 	tablespace_name=upper('&1')
/

--set feed on

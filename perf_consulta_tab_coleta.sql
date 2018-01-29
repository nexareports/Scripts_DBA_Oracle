set lines 250
set pages 1000
col segment_name format a35

Select	Owner,
	Segment_name,
	Bytes/1024/1024 Mb
From
	Dba_Segments 
Where
	Segment_name like 'TB_LOAD_PROFILE%'
Order by 1,2
/	



Select	'Drop table '||Owner||'.'||Segment_name||';' DROP_DDL
From
	Dba_Segments 
Where
	Segment_name like 'TB_LOAD_PROFILE%'
Order by Owner,Segment_Name
/	

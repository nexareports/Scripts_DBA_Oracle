ACCEPT OWNER CHAR PROMPT "ENTER OWNER NAME : " 
ACCEPT TABNAME CHAR PROMPT "ENTER TABLE NAME : " 
COL count Heading "Rows" 
COL name HEADING "File Name " for a60 
--set verify off 

select name ,t.count from 
v$datafile d, 
(select count(*) count ,dbms_rowid.rowid_relative_fno(rowid) file# 
from &&OWNER..&&TABNAME group by dbms_rowid.rowid_relative_fno(rowid)) t 
where t.file#=d.file# 
/ 
undefine OWNER 
undefine TABNAME 
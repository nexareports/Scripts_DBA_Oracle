--set verify off 
def owner	= &&1 
def index_name	= &&2 
def column_name	= &&3 
 
col rdblks     format   99990  heading '# Data Blks'           justify c  
col tlfblks    format   99990  heading 'Leaf Blocks'           justify c 
col tindxblks  format   99990  heading '# Index Blks'          justify c 
col rowsel     format  99.999  heading 'Row Sel.'              justify c 
col blksel     format  99.999  heading 'Block Sel.'            justify c 
col totblks    format 9999990  heading 'Total Blocks Required' justify c 
col table_name format     a20  heading 'Table Name'            justify c 
 
col val5 new_val table_name noprint 
select table_name val5 
from   dba_indexes 
where  table_owner = upper('&owner') and 
       index_name  = upper('&index_name') 
/ 
col val2 new_val trows noprint 
select count(*) val2 from &owner..&table_name 
/ 
validate index &owner..&index_name 
/ 
col val3 new_val tlfblks noprint 
col val4 new_val tndxht noprint 
select lf_blks val3, height val4 from index_stats; 
/ 
ttitle -   
  center  'Number Of Data Blocks Read For A Full Table Scan' , skip 2 
 
 
col val1 new_val totblks format 99999 heading 'Data Blocks' justify c 
select count(distinct(substr(rowid,15,4)||substr(rowid,1,8))) val1  
from &owner..&table_name 
/ 
ttitle - 
 'Data Distribution for &owner..&table_name:&index_name' skip 2 
 
select &column_name, 
       count(distinct(substr(rowid,15,4)||substr(rowid,1,8))) rdblks, 
       (count(*)/&trows) * &tlfblks + &tndxht tindxblks, 
       count(*)/&trows rowsel, 
       count(distinct(substr(rowid,15,4)||substr(rowid,1,8)))/&totblks blksel 
from   &owner..&table_name 
group  by &column_name 
order  by 2 desc, 1 asc 
/ 
 
undef owner_name 
undef column_name 
undef index_name 
--set verify on


col column_name format a30
Select column_name,count(*)
from dba_tab_histograms
where owner='&1' and table_name='&2'
group by column_name
order by 2 desc;
col column_name clear

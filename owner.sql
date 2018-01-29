col owner for a30
select owner,object_type,count(*) from dba_objects where owner=upper('&1') group by owner,object_type order by 3 desc;
col owner clear
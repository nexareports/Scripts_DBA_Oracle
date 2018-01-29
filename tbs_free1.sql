select c.tablespace_name, d.total, c.free, c.free/d.total*100 perc_free from (
select a.tablespace_name, sum(a.bytes)/1024/1024 free from dba_free_space a
group by a.tablespace_name) c
, (select b.tablespace_name, sum(b.bytes)/1024/1024 total from dba_data_files b
group by b.tablespace_name
) d
where c.tablespace_name=d.tablespace_name
and c.tablespace_name='&tbs'
/
 
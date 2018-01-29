col object_name for a35
select owner,object_type,object_name,timestamp from dba_objects
where 
(timestamp like substr(to_char(sysdate-1,'YYYY-MM-DD:HH24'),1,12)||'%'
or
timestamp like substr(to_char(sysdate,'YYYY-MM-DD:HH24'),1,12)||'%')
order by timestamp;

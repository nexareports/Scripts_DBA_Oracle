select * from v$osstat;
select value/1024/1024 from v$osstat where stat_name='PHYSICAL_MEMORY_BYTES';
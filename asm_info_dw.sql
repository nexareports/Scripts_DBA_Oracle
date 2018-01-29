set lines 300 pages 3000
select name, round(free_mb/1024,0) free_gb, round(total_mb/1024,0) total_gb, round(free_mb*100/total_mb,0) pct_free 
from v$asm_diskgroup where name like '%&1%'
order by name;


--col path for a40
--select path, name, header_status, os_mb/1024 os_gb, round(free_mb/1024,0) free_gb, total_mb/1024 total_gb from v$asm_disk order by name;
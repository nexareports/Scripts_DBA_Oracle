set lines 300 pages 3000
select name, free_mb, total_mb, round(free_mb*100/total_mb,0) pct_free from v$asm_diskgroup order by name;


col path for a40
select path, name, header_status, os_mb, free_mb, total_mb from v$asm_disk order by name,path;
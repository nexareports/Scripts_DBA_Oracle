set lines 300 pages 3000
col path for a40
select path, name, header_status, round(os_mb/1024,0) os_gb, round(free_mb/1024,0) free_gb, round(total_mb/1024,0) total_gb from v$asm_disk where name like '%&1%' order by name;
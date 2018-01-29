set lines 200 pages 1000
col path a40
SELECT SUBSTR(d.name,1,16) AS asmdisk, d.mount_status, d.state,
     dg.name AS diskgroup FROM V$ASM_DISKGROUP dg, V$ASM_DISK d
     WHERE dg.group_number = d.group_number
order by 1;



SELECT SUBSTR(d.name,1,16) AS asmdisk, d.path, d.mount_status, d.state,
     dg.name AS diskgroup FROM V$ASM_DISKGROUP dg, V$ASM_DISK d
     WHERE dg.group_number(+) = d.group_number
order by 1;



SELECT SUBSTR(d.name,1,16) AS asmdisk, d.path, d.mount_status, d.CREATE_DATE, d.state,
     dg.name AS diskgroup FROM V$ASM_DISKGROUP dg, V$ASM_DISK d
     WHERE dg.group_number(+) = d.group_number
order by 1;

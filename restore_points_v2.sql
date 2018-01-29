col time for a40
col name for a40
col scn for 999999999999
select scn, guarantee_flashback_database, round(storage_size/1048576) STORAGE_SIZE_MB, time, name from v$restore_point;
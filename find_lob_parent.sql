SELECT TABLE_NAME, column_name
FROM   dba_lobs
WHERE  segment_name = (SELECT object_name
                       FROM   dba_objects
                       WHERE  object_name = UPPER('SYS_IL0000073911C00003$$')
                       AND    object_type = 'LOB');
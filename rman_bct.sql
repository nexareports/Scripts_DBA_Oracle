select file#,
            avg(datafile_blocks),
            avg(blocks_read),
            avg(blocks_read/datafile_blocks) * 100 as "% read for backup"
       from v$backup_datafile
      where incremental_level > 0
        and used_change_tracking = 'YES'
      group by file#
      order by file#;
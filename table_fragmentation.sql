SELECT   owner,
         table_name,
         blocks,
         num_rows,
         avg_row_len,
         ROUND ( ( (blocks * 8 / 1024)), 2) TOTAL,
         ROUND ( (num_rows * avg_row_len / 1024 / 1024), 2) ATUAL,
         ROUND (
            ( (blocks * 8 / 1024) - (num_rows * avg_row_len / 1024 / 1024)),
            2
         ) EXTRA
  FROM   all_tables
 WHERE   owner='PGSBLDB'
 and last_analyzed is not null
 order by extra desc;
col target_name for a35
col diskgroup for a12
col REDUNDANCY for a10
col PERCENT_USED for a10
col TOTAL_GB for 999999.99
col USABLE_TOTAL_GB for 999999.99
col FREE_GB for 999999.99
col USABLE_FREE_GB for 999999.99
col NO_OF_DISK for a8
col LUN_SIZE for 999999.99
col REBAL_PENDING for a10
col IMBALANCE for a10

SELECT target_name,
         diskgroup,
         --MAX (DECODE (seq, 7, VALUE)) REDUNDANCY,
         MAX (DECODE (seq, 4, VALUE)) PERCENT_USED,
         MAX (DECODE (seq, 6, ceil(VALUE/1024))) TOTAL_GB,
         MAX (DECODE (seq, 9, ceil(VALUE/1024))) USABLE_TOTAL_GB,
         MAX (DECODE (seq, 3, ceil(VALUE/1024))) FREE_GB,
         MAX (DECODE (seq, 8, ceil(VALUE/1024))) USABLE_FREE_GB,
         MAX (DECODE (seq, 2, VALUE)) NO_OF_DISK,
         ceil(( MAX (DECODE (seq, 6, ceil(VALUE/1024)))) /(MAX (DECODE (seq, 2, VALUE)))) LUN_SIZE,
         MAX (DECODE (seq, 5, decode(VALUE,'No','',value))) REBAL_PENDING,
         MAX (DECODE (seq, 1, VALUE)) IMBALANCE
    FROM (SELECT target_name,
                 key_value diskgroup,
                 VALUE,
                 metric_column,
                 ROW_NUMBER ()
                 OVER (PARTITION BY target_name, key_value
                       ORDER BY metric_column)
                    AS seq
            FROM MGMT$METRIC_CURRENT
          WHERE        target_type in ('osm_instance','osm_cluster')
                   AND metric_column IN
                          ('rebalInProgress',
                           'free_mb',
                           'usable_file_mb',
                           'type',
                           'computedImbalance',
                           'usable_total_mb',
                           'percent_used','diskCnt')
                OR (    metric_column = 'total_mb'
                    AND metric_name = 'DiskGroup_Usage'))
GROUP BY target_name, diskgroup
order by 1,2;
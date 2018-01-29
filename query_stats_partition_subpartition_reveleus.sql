  SELECT   s.table_name,
           s.partition_name,
           s.subpartition_name,
           s.last_analyzed last_analyzed_subpart,
           p.last_analyzed last_analyzed_part,
           s.num_rows num_rows_subpart,
           p.num_rows num_rows_part
    FROM   user_tab_subpartitions s, user_tab_partitions p
   WHERE   p.partition_name = s.partition_name AND p.table_name = s.table_name
           AND s.partition_name =
                 (  SELECT   MAX (partition_name) FROM user_tab_partitions)
ORDER BY   4 DESC;
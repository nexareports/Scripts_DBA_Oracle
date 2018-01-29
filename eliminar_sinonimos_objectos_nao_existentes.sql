/* Formatted on 2010/08/27 14:49 (Formatter Plus v4.8.8) */
SELECT   s.owner, s.synonym_name, s.table_owner, s.table_name
    FROM SYS.dba_synonyms s
   WHERE NOT EXISTS (
                SELECT 'x'
                  FROM SYS.dba_objects o
                 WHERE o.owner = s.table_owner
                       AND o.object_name = s.table_name)
     AND db_link IS NULL
     AND s.owner <> 'PUBLIC'
ORDER BY 1
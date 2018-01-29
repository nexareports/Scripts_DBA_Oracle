ANALYZE TABLE BASEL2.FCT_MITIGANTS PARTITION (REV_2012MAY31) COMPUTE STATISTICS;
ANALYZE TABLE BASEL2.FCT_NON_SEC_EXPOSURES PARTITION (REV_2012MAY31) COMPUTE STATISTICS;
ANALYZE TABLE BASEL2.EXP_MITIGANT_MAPPING PARTITION (REV_2012MAY31) COMPUTE STATISTICS;

--Executar o output do comando (escolher a tabela)
SELECT      'exec  DBMS_STATS.GATHER_TABLE_STATS (ownname=>'''||table_owner||''',tabname=>'''|| table_name||''',partname=>'''||MAX(partition_name)||''',method_opt=>''FOR ALL COLUMNS SIZE AUTO'',estimate_percent=>40,CASCADE=>TRUE,granularity=>''ALL'',DEGREE=>6);'
    FROM   DBA_TAB_PARTITIONS
   WHERE                                                          --num_rows=0
        table_owner = 'BASEL2'
AND table_name = 'FCT_NON_SEC_EXPOSURES_SPLIT'
-- AND SUBSTR (partition_name, 5) = '2012MAY31';
GROUP BY   table_owner, table_name;

--exec  DBMS_STATS.GATHER_TABLE_STATS (ownname=>'BASEL2',tabname=>'FCT_NON_SEC_EXPOSURES_SPLIT',partname=>'REV_2012MAY31',method_opt=>'FOR ALL COLUMNS SIZE AUTO',estimate_percent=>40,CASCADE=>TRUE,granularity=>'ALL',DEGREE=>6);
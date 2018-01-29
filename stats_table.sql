set feedback on
EXEC DBMS_STATS.gather_table_stats('&Owner', '&Tabela_',Cascade=> &Cascade_);
set feedback on
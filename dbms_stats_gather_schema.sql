exec dbms_stats.gather_table_stats(OWNNAME=>'&OWN',TABNAME=>'&TAB', estimate_percent => &EST, method_opt => &METODO ,cascade=> TRUE,degree=>4);

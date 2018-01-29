------------------------ <begin script > ---------------------------------------
    spool awr_check_out.log
    set serveroutput on
    set timing on
    set echo on
    
    
    -- disable flush and purge while we gather information
    
    alter system set "_swrf_mmon_flush" = false;
    
    -- 1) check how many rows are in the different tables
    
    select count(*) from wrh$_sqlstat;
    select count(*) from wrh$_sqlstat_bl;
    select count(*) from wrh$_sqltext;
    select count(*) from wrh$_sql_plan;
    
    select count(*) from
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    -- 2) check rows in growth tables that could/should be purged
    
    select count(sql_id) from wrh$_sqltext  where ref_count = 0 and sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    select count(sql_id) from wrh$_sql_plan where sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    -- 3) check what could be limiting purge
    
    col baseline_name form a20
    select * from wrm$_baseline order by baseline_id;
    
    select count(*) from wrh$_sqltext where ref_count != 0;
    
    -- 4) use delete with rownum < ... to get a ballpark figure for the time
    
    delete from wrh$_sqltext where /*rownum < 1001 and*/ ref_count = 0 and sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    rollback;
    
    delete from wrh$_sql_plan where /*rownum < 1001 and*/ sql_id not in
     (select sql_id from wrh$_sqlstat union select sql_id from wrh$_sqlstat_bl);
    
    rollback;
    
    --5) Query the output od DBA_HIST_WR_CONTROL
    
    select * from  dba_hist_wr_control;
    
    -- re-enable flush and purge
    
    alter system set "_swrf_mmon_flush" = true;
    
    spool off;
    
    ------------------------ <end script > ---------------------------------------
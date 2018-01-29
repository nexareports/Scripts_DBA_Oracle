set long 2000000 longchunksize 2000000 pagesize 0 linesize 400 feedback off verify off trimspool on echo off termout off

column fn new_value filename

SELECT sys_context('USERENV', 'INSTANCE_NAME')||'_TABLES_'||to_char(sysdate, 'yyyymmddhh24miss')||'.log' as fn from dual;

spool &filename

--This line add a semicolon at the end of each statement
execute dbms_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',true);

select dbms_metadata.get_ddl('TABLE','RECS_TYPE_17','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_16','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_14','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_3','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_23','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_14','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_6','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_50','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','FP_M_FIRE06','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_4','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_20','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_8','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_13','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_14','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_16','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_150','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_8','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_9','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_12','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_3','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_9','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','SA_FIRE06','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_220','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_11','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_200','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_40','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_15','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_17','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_11','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_210','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_7','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_100','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_30','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_2','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_2','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','SA_FIRE52','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','SA_FIRE18','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','SA_FIRE11','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','FP_M_FIREAO','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','FP_M_FIRE18','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','FP_M_FIRE13','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_17','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_7','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_5','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_11','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_13','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_23','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_40','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_5','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_210','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_100','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_150','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_50','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_220','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_8','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_21','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_2','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_50','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_1','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','SA_FIRE13','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','FP_M_FIRE52','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_6','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_3','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_21','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','FRG_AUX_GAR','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_6','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_30','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_15','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_16','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','FRG_AUX_CRT','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_12','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_12','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_7','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_21','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_220','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_5','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_210','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_200','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_40','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_1','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_22','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_20','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_23','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_100','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_150','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_4','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_15','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_20','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_1','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_13','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_9','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_200','FRGBAC') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_4','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_30','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_22','FRGBEST') from dual;
select dbms_metadata.get_ddl('TABLE','RECS_TYPE_22','FRGBES') from dual;
select dbms_metadata.get_ddl('TABLE','SA_FIREAO','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','SA_FIRE51','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','FP_M_FIRE51','FRGGAR') from dual;
select dbms_metadata.get_ddl('TABLE','FP_M_FIRE11','FRGGAR') from dual;

   
spool off   


--select 'select dbms_metadata.get_ddl(''TABLE'','''||table_name||''','''||table_owner||''') from dual;' from dba_tab_partitions where num_rows = 0 and table_owner in ('FRGBES','FRGBAC','FRGBEST','FRGGAR');
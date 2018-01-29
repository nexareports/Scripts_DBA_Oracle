--set long 2000000000
--set pages 1000
--set lines 250
--set serveroutput on size 200000000
select DBMS_METADATA.GET_DDL(upper('&Tipo_Obj'),upper('&Nom_Obj'),upper('&Owner_')) from dual
/


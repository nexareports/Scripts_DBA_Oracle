--set feedback off
--set lines 250
--set pages 1000
col comments format a180
prompt
--set verify off
select table_name,comments from dictionary where table_name like upper('%&1%');
--set feedback on
prompt

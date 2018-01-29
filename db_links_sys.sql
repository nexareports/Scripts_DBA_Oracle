set pages 999
set head off
set feedback off
set linesize 150
spool /oracle/CLNSIN/admin/adhoc/refresh_qa/STEP2_QA_NOVA/CRIA/99_cria_dblinks.sql
select 'connect '||a.OWNER||'/temp_10passwd ;'||chr(10)||'create database link "'||a.DB_LINK||'" connect to "'||a.username||'" identified by "'||b.password||'" using '''||a.host||''';'
from dba_db_links a, sys.link$ b
where a.username=b.userid
and a.host=b.host
/
spool off
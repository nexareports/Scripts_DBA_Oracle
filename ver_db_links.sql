select a.*, b.PASSWORD, b.HOST
from dba_db_links a, sys.link$ b                           
where a.username=b.userid                                  
and a.host=b.host                                          
and owner='REP_PIS'         
                               
select 'connect '||a.OWNER||'/temp_10passwd ;'||chr(10)||'create database link "'||a.DB_LINK||'" connect to "'||a.username||'" identified by "'||b.password||'" using '''||a.host||''';' 
from dba_db_links a, sys.link$ b 
where a.username=b.userid 
and a.host=b.host
and owner='YSAPA02'  
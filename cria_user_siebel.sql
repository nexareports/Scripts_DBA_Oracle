undefine 1

set termout off

column arq new_value Arquivo
select 'C:\Logs\User\User_Siebel_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from dual;
spool &Arquivo

set termout on


create user &&1
identified by &&1
default tablespace USERS
temporary tablespace TEMP
password expire;


grant SBL_CON to &&1;
grant SSE_ROLE to &&1;
grant CREATE SESSION to &&1;


prompt Foi criado o user &&1 na BD de desenvolvimento.
prompt Foi criado o user &&1 na BD de testes.
prompt A password foi comunicada telefonicamente.
prompt

undefine 1
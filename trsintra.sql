undefine 1

set termout off

column arq new_value Arquivo
select 'C:\Logs\Acessos\Acessos_Sintra_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from dual;
spool &Arquivo

set termout on

Prompt VERIFICAR EXISTÊNCIA DO(S) USER(S)
@dba_users '&&1'
pause

Prompt VERIFICAR ROLES DO(S) USER(S)
@dba_role_privs '&&1'
Prompt VERIFICAR SINÓNIMOS DO USER
@dba_synonyms '&&1'
pause

Prompt ATRIBUIR ROLES E SINÓNIMOS AO(S) USER(S) - EXECUTAR UMA VEZ PARA CADA USER
EXEC P_SET_USER_SINTRA('&&1');

pause
Prompt VERIFICAR ROLES E SINÓNIMOS DO(S) USER(S)
@dba_role_privs '&&1'
@dba_synonyms '&&1'
pause

spool off

prompt Foram dados privilégios ao user &&1 para aceder a SINTRA
prompt É favor testar
prompt O user &&1 possui privilégios para aceder a SINTRA.
prompt É favor testar
undefine 1
prompt A conectar daa@e49.pt
conn daa@e49.pt

set termout off

column arq new_value Arquivo
select 'C:\Logs\Acessos\Acessos_Discoverer_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from dual;
spool &Arquivo

set termout on

Prompt VERIFICAR EXISTÊNCIA DO(S) USER(S)
@dba_users
pause

Prompt VERIFICAR ROLES DO(S) USER(S)
@dba_role_privs
Prompt VERIFICAR SINÓNIMOS DO USER
@dba_synonyms
pause

Prompt CONSULTAR CÁBULAS - EXECUTAR UMA VEZ PARA CADA USER

pause
Prompt VERIFICAR ROLES E SINÓNIMOS DO(S) USER(S)
@dba_role_privs
@dba_synonyms
pause

spool off

Os privilégios necessários para o(s) utilizador(es) aceder(em) ao DISCOVERER foram concendidos.
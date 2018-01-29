prompt A conectar daa@e45.pt
conn daa@e45.pt


set termout off

column arq new_value Arquivo
select 'C:\Logs\Acessos\Acessos_Sintra_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from dual;
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

Prompt ARIIBUIR ROLES E SINÓNIMOS AO(S) USER(S) - EXECUTAR UMA VEZ PARA CADA USER
EXEC P_SET_USER_SINTRA('&user');

pause
Prompt VERIFICAR ROLES E SINÓNIMOS DO(S) USER(S)
@dba_role_privs
@dba_synonyms
pause

spool off

prompt O utilizador possui privilégios para poder aceder ao SINTRA,
prompt no entanto, como a BD de HISTÓRICO é de READ ONLY, estas alterações apenas terão efeito amanhã 
prompt após o refresh da BD.
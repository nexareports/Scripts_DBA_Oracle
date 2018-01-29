set pagesize 1000
set termout off

column arq new_value Arquivo
select 'C:\Logs\Pacotes\'||user||'@'||d.name||'_'||to_char(sysdate,'yyyymmdd_hh24mi')||'.log' arq from v$database d;
spool &Arquivo

set termout on
prompt INTRODUZIR PACOTE
pause
prompt ------------------

set termout off

col sqpromp noprint new_value sq_promp
select distinct a.host_name||'.'||c.osuser||'.'||user||'@'||a.instance_name||'.'||'SID='||b.sid sqpromp
from v$instance a, v$mystat b, v$session c
where c.username is null and c.osuser is not null
/
define sq_promp=&&sq_promp

set sqlprompt &&sq_promp> 

undefine sq_promp

set termout on
prompt PESQUISA OBJECTOS INVÁLIDOS ANTES DE INSTALAÇÃO
SELECT 'ALTER '||                                                         
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' PACKAGE ',OBJECT_TYPE)||       
       ' '||                                                              
       OBJECT_NAME||                                                      
       ' '||                                                              
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' COMPILE BODY ;','COMPILE ;')   
FROM USER_OBJECTS                                                         
WHERE  STATUS = 'INVALID'                                                 
ORDER  BY OBJECT_TYPE,OBJECT_TYPE ; 

prompt ---------------------------- PRONTO A INSTALAR PACOTE ---------------------------------

pause
prompt PESQUISA OBJECTOS INVÁLIDOS APÓS INSTALAÇÃO 
pause  
SELECT 'ALTER '||                                                         
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' PACKAGE ',OBJECT_TYPE)||       
       ' '||                                                              
       OBJECT_NAME||                                                      
       ' '||                                                              
       DECODE(OBJECT_TYPE,'PACKAGE BODY',' COMPILE BODY ;','COMPILE ;')   
FROM USER_OBJECTS                                                         
WHERE  STATUS = 'INVALID'                                                 
ORDER  BY OBJECT_TYPE,OBJECT_TYPE ; 
  

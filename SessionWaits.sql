select
   event,
   count(*) qtd
from
   v$session_wait
group by
   event
order by 
      2 desc
/

prompt __________________________
prompt @infouser

Select * from (With tmp as (
     select count(*) soma from gv$active_session_history
     where session_state='ON CPU' and session_type='FOREGROUND' and sample_time>sysdate-(1/24/4)
            )
Select sql_id,Count(*)"No Eventos",Round(count(*)*100/max(soma),2) "% CPU"
from gv$active_session_history,tmp 
where session_state='ON CPU'
and sample_time>sysdate-(1/24/4) and session_type='FOREGROUND' 
group by sql_id order by 2 desc) where rownum<21;
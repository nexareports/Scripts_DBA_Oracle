Select * from (
Select event,Count(*)"No Eventos",sum(time_waited) "Time Waited"
from dba_hist_active_sess_history
where snap_id between &1 and &2 
group by event order by 3 desc) where rownum<21;
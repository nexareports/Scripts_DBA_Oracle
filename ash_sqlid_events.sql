select 
case SESSION_STATE
when 'WAITING' then event
else SESSION_STATE
end TIME_CATEGORY,
(count(*)*10) seconds
from DBA_HIST_ACTIVE_SESS_HISTORY a,
V$INSTANCE i,
dba_users u
where 
a.user_id = u.user_id and
a.instance_number = i.instance_number and
a.user_id = u.user_id and
sample_time>trunc(sysdate)
--sample_time  between to_date('2013-04-02 00:00','YYYY-MM-DD HH24:MI') and  to_date('2013-04-02 22:00','YYYY-MM-DD HH24:MI')
and
a.sql_id = '&1'
group by SESSION_STATE,EVENT
order by seconds desc;


PROMPT ########################################################################################################
select
    event,
    time_waited "time_waited(s)",
    case when time_waited = 0 then 
        0
    else
        round(time_waited*100 / sum(time_waited) Over(), 2)
    end "percentage"
from
    (
        select event, sum(time_waited) time_waited
        from dba_hist_active_sess_history
        where sql_id = '&1'
        group by event
    )
order by
    time_waited desc;
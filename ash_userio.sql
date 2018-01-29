Select * from (
with tmp as (select COUNT(*) tot,sum(time_waited) Tim FROM gv$active_session_history ash, v$event_name evt WHERE ash.session_state = 'WAITING' AND ash.event_id = evt.event_id AND evt.wait_class = 'User I/O')
SELECT sql_id, COUNT(*) QTD,round(count(*)*100/max(c.tot),2) "% Qtd",sum(time_waited) "Time Waited",round(sum(time_waited)*100/max(c.tim),2) "% Time Waited"
FROM gv$active_session_history ash, v$event_name evt, tmp c
WHERE ash.session_state = 'WAITING'
AND ash.event_id = evt.event_id
AND evt.wait_class = 'User I/O'
GROUP BY sql_id
ORDER BY COUNT(*) desc) where rownum<11;
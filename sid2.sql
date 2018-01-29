Select event,count(*) CNT, round(sum(time_waited)/1000,2) "Time Waited(s)" from v$active_session_history
where (session_id,session_serial#) in (select sid,serial# from v$session where sid=&1) group by event order by 3 desc;

Select sql_id,count(*) CNT, round(sum(time_waited)/1000,2) "Time Waited(s)" from v$active_session_history
where (session_id,session_serial#) in (select sid,serial# from v$session where sid=&1) group by sql_id order by 3 desc;

Select sql_id,event,count(*) CNT, round(sum(time_waited)/1000,2) "Time Waited(s)" from v$active_session_history
where (session_id,session_serial#) in (select sid,serial# from v$session where sid=&1) group by sql_id,event order by 4 desc;

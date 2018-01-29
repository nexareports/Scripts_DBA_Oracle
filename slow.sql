select * from 
	(
	Select event,count(*) CNT, sum(time_waited) "Time Waited", round(sum(time_waited)*100/(select sum(time_waited) from v$active_session_history where sample_time>sysdate-1/24/4),2) "%"
	from v$active_session_history 
	where sample_time>sysdate-1/24/4
	group by event order by 3 desc
	) 
where rownum<11;

select * from 
	(
	Select module,count(*) CNT, sum(time_waited) "Time Waited", round(sum(time_waited)*100/(select sum(time_waited) from v$active_session_history where sample_time>sysdate-1/24/4),2) "%"
	from v$active_session_history 
	where sample_time>sysdate-1/24/4
	group by module order by 3 desc
	) 
where rownum<11;

select * from 
	(
	Select machine,count(*) CNT, sum(time_waited) "Time Waited", round(sum(time_waited)*100/(select sum(time_waited) from v$active_session_history where sample_time>sysdate-1/24/4),2) "%" 
	from v$active_session_history 
	where sample_time>sysdate-1/24/4
	group by machine order by 3 desc
	) 
where rownum<11;
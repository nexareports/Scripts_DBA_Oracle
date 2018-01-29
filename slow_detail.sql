col event for a30
col module for a25
col machine for a20
select * from 
	(
	Select 
		event,
		module,
		machine,
		count(*) CNT, 
		sum(time_waited) "Time Waited", 
		round(sum(time_waited)*100/(select sum(time_waited) from v$active_session_history where sample_time>sysdate-1/24/4),2) "%" 
	from v$active_session_history 
	where sample_time>sysdate-1/24/4
	and SESSION_STATE='WAITING'
	group by
		event,
		module,
		machine order by "%" desc
	) 
where rownum<11;

select * from 
	(
	Select 
		sql_id,
		event,
		module,
		machine,
		count(*) CNT, 
		sum(time_waited) "Time Waited", 
		round(sum(time_waited)*100/(select sum(time_waited) from v$active_session_history where sample_time>sysdate-1/24/4),2) "%" 
	from v$active_session_history 
	where sample_time>sysdate-1/24/4
	and SESSION_STATE='WAITING'
	group by
		sql_id,
		event,
		module,
		machine order by "%" desc
	) 
where rownum<11;


col event clear
col module clear
col machine clear


--SESSION_STATE
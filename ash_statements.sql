col "PCT%" for a20
with 
hist as (
	Select trunc(b.begin_interval_time,'DD') DATA,sum(a.executions_delta) Executions
	from dba_hist_sqlstat a, dba_hist_snapshot b
	where a.snap_id=b.snap_id
	group by trunc(b.begin_interval_time,'DD')
	order by 1
	),
total as (
	Select sum(x.executions_delta) total from dba_hist_sqlstat x
	)
Select Data,Executions,lpad('#',Executions*100/total,'#') as "PCT%" from hist, total;

/*
select username, sess_count,
       -- tot_sess_count, pct_of_tot,
       lpad('|',pct_of_tot,'|') as pct_of_tot_bar_graph
from
(
select du.username, count(distinct s.sid) sess_count,
        sum(count(distinct s.sid)) over () tot_sess_count,
        round((count(distinct s.sid) / sum(count(distinct s.sid)) over ())*100,0) pct_of_tot
from gv$session s, dba_users du
where du.username like 'MY%'
and du.username != 'MY_REPORTING'
and du.username = s.username(+)
group by du.username
order by du.username
)
/
*/
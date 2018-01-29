

set lines 220 pages 3000

col target_name for a70
col tbs_name for a30
col "spaceUsed_GB" for 999999999.9
col "spaceAllocated_GB" for 999999999.9
col "growth_GB" for 999999999.9

compute avg lab "Average Growth" of "growth_GB" on report
break on report

select target_name,
key_value tbs_name, 
rollup_timestamp month, 
stat_1 "spaceAllocated_GB",
stat_0 "spaceUsed_GB", 
stat_0-(lag(stat_0,1,null) over (order by rollup_timestamp)) as "growth_GB"
from (
	select
	m.target_name ,
	m.key_value,
	to_char(m.rollup_timestamp,'YYYY-MM') rollup_timestamp,
	m.metric_column,
	round(max(m.average)/1024,1) average
	from
	mgmt$metric_daily m ,
	mgmt$target_type t
	where
	(t.target_type ='rac_database'
	or (t.target_type ='oracle_database'
	and t.type_qualifier3 != 'RACINST'))
	and m.target_guid = t.target_guid
	and m.metric_guid =t.metric_guid
	and t.metric_name ='tbspAllocation'
	and m.target_name like '&db'
	and m.key_value = upper('&tbs_name')
	and m.rollup_timestamp >= sysdate-365
	and m.rollup_timestamp <= sysdate
	group by m.target_name,m.key_value, to_char(m.rollup_timestamp,'YYYY-MM'),m.metric_column)
pivot(
	max(average) for metric_column in ('spaceUsed' stat_0 ,'spaceAllocated' stat_1)
	)
order by target_name,key_value, rollup_timestamp;

clear breaks

prompt . @em_tbs_growth
prompt

		

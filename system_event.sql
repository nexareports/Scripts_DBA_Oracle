set lines 250 pages 1000
col Event format a35
col Waits format a15
col Timeouts format a10
col "Total Wait Time (s)" format 9,999,999,999,999,999
select 		event	 			  		Event,
 		to_char(round(total_waits))	  		Waits,
 		to_char(round(total_timeouts))	  		Timeouts,
 		round(time_waited_micro)			"Total Wait Time (s)"
from 		v$system_event
where		total_timeouts > 1
order by 	time_waited_micro desc
/

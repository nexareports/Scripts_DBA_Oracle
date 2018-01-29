clear break 
clear compute 
break on report 
compute sum of owned on report 
compute avg of pctbusy on report 
compute avg of avgwait on report 
 
col name format a4 heading "Name" 
col pname format a20 heading "Name" 
col value format a55 heading "Value" 
col circuit heading "Circuit" 
col dispatcher heading "Dispatcher" 
col server heading "Server" 
col queue heading "Queue" 
col waiter heading "Waiter" 
col net format a4 heading "Net" 
col owned format 9990 heading "Owned" 
col status format a8 heading "Status" 
col type format a10 heading "Type" 
col queued format 990 heading "Queued" 
col sid format a10 heading "Session|ID,Serial#" 
col rqst_tot format 999,999,990 heading "Total Rqsts" 
col rqst_hr format 999,990.000 heading "Rqst/Hour" 
col rqst_min format 999,990.000 heading "Rqst/Min" 
col pctbusy format 990.000 heading "%Busy" 
col avgwait format 990.000 heading "Avg Wait" 
col maximum_connections heading "Maximum|Connections" 
col servers_started heading "Servers|Started" 
col servers_terminated heading "Servers|Terminated" 
col servers_highwater heading "Servers|HighWater" 
 
--set pages 100 feedback off verify off 
 
col instance noprint new_value V_SID 
col open_mins noprint new_value V_OPEN_MINS 
select	instance,  
	(to_number(to_char(sysdate - 
			   to_date(open_time, 
				   'MM/DD/YY HH24:MI:SS'))) * 1440) open_mins 
from	v$thread; 
 
prompt 
prompt MTS Dispatcher Statistics: 
select	d.name, 
	substr(d.network,1,15) net, 
	d.owned, 
	d.status, 
	decode(q.type,'COMMON','INCOMING',q.type) type, 
	q.queued, 
	(d.busy/(d.busy+d.idle))*100 pctbusy, 
	decode(q.totalq,0,0,q.wait/q.totalq) avgwait 
from	v$queue		q, 
	v$dispatcher	d 
where	q.paddr (+) = d.paddr 
/ 
 
prompt 
prompt 
prompt MTS Shared Server Statistics: 
select	name, 
	requests rqst_tot, 
	requests / (&&V_OPEN_MINS / 60) rqst_hr, 
	requests / &&V_OPEN_MINS rqst_min, 
	(busy/(busy+idle))*100 pctbusy 
from	v$shared_server	s 
/ 
 
prompt 
prompt 
prompt MTS "Active Circuit" Statistics: 
select	c.circuit, 
	to_char(s.sid) || ',' || to_char(s.serial#) sid, 
	d.name dispatcher, 
	ss.name server, 
	substr(c.queue,1,8) queue, 
	c.waiter 
from	v$circuit	c, 
	v$session	s, 
	v$dispatcher	d, 
	v$shared_server	ss 
where	s.saddr = c.saddr 
and	d.paddr = c.dispatcher 
and	ss.paddr = c.server 
/ 
 
prompt 
prompt 
prompt Cumulative MTS Statistics: 
select	* 
from	v$mts 
/ 
 
prompt 
prompt 
prompt MTS configuration parameters: 
select	name pname, 
	value 
from v$parameter 
where	name like 'mts%' 
/ 
spool off 
--set feedback on verify on
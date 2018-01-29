select a.execution_end, b.type, b.impact, d.rank, d.type, 
'Message           : '||b.message MESSAGE,
'Command To correct: '||c.command COMMAND,
'Action Message    : '||c.message ACTION_MESSAGE
From dba_advisor_tasks a, dba_advisor_findings b,
     Dba_advisor_actions c, dba_advisor_recommendations d
Where a.owner=b.owner and a.task_id=b.task_id
And b.task_id=d.task_id and b.finding_id=d.finding_id
And a.task_id=c.task_id and d.rec_id=c.rec_Id
And a.task_name like 'ADDM%' and a.status='COMPLETED' 
and a.execution_end > trunc(sysdate)
Order by   rank ;
--a.execution_end desc,

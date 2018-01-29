Prompt ####################################################################
Prompt ##              Users                                             ##
Prompt ####################################################################

select ses.username
, substr(ses.program, 1, 19) command
, tra.used_ublk, tra.START_DATE, tra.USED_UREC,tra.status
from v$session ses
, v$transaction tra
where ses.saddr = tra.ses_addr;


Prompt ####################################################################
Prompt ##              SMON                                              ##
Prompt ####################################################################

select usn, state, undoblockstotal "Total", undoblocksdone "Done", undoblockstotal-undoblocksdone "ToDo", decode(cputime,0,'unknown',sysdate+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400)) 
"Estimated time to complete" from v$fast_start_transactions; 

select * from v$fast_start_transactions;
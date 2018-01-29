set pages 10000
select 'execute sys.dcsi_altersystem.all_killsession('||sid||','||serial#||');'
from v$session

spo mata.txt
/
spo off
@mata.txt
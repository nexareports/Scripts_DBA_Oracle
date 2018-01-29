--Process Orphans
SELECT 'ps -ef |grep ' ||pr.spid||'' as ps,'kill -9 ' ||pr.spid||'' as comando,PR.ADDR, PR.USERNAME,PR.TERMINAL,PR.PROGRAM
from  V$PROCESS PR
WHERE PR.USERNAME IS NOT NULL
AND NOT EXISTS (SELECT SE.SID FROM V$SESSION SE 
                 WHERE SE.PADDR=PR.ADDR);

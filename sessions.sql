select status, count(*)
from v$session
group by status;
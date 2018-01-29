select count(*), owner 
from dba_synonyms 
where owner in (
'&&1'
) group by owner;
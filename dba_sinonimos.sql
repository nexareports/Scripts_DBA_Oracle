select count(*), owner 
from dba_synonyms 
where owner in (
&conj_users
) group by owner;

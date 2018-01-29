Col grantee for a120
col owner for a12
col read for a1
col write for a1

with grants as (
select 
OWNER,
GRANTEE,
SUM(case when privilege='SELECT' then 1 else 0 end) as Read,
sum(Case when (privilege='INSERT' or privilege='DELETE' or privilege='UPDATE') then 1 else 0 end) as Write
from DBA_TAB_PRIVS
where OWNER='&1'
group by OWNER,GRANTEE order by 1)
--
select 
OWNER,
(case when SUBSTR(a.GRANTEE,1,3)='RL_' 
  then a.grantee||' ('||(select LISTAGG(Y.GRANTEE, ', ') within group (order by Y.GRANTEE) from DBA_ROLE_PRIVS Y where Y.GRANTED_ROLE=a.GRANTEE) ||')'
  else a.grantee end)  Grantee,
case when read>0 then 'Y' else 'N' end as read,
case when write>0 then 'Y' else 'N' end as write
from GRANTS a;

col grantee clear
col owner clear
col read clear
col write clear
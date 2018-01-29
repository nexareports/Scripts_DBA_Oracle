set pages 10000
set lines 160
col to_char(LAST_ANALYZED,'YYYY/MM/DD') for a30

select owner, to_char(LAST_ANALYZED,'YYYY/MM/DD'), count(*)
from dba_tables
group by owner, to_char(LAST_ANALYZED,'YYYY/MM/DD')
/

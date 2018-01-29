--set lines 250 pages 1000
select      type,
            count(*) QTD
from        dba_dependencies
where       referenced_name in (upper('&1'))            
group by    type
order by    2 desc
/


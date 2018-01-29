Select segment_type,count(*) QTD,round(sum(bytes)/1024/1024) MB
from dba_segments where owner='&1'
group by segment_type
order by 1;

Select count(*) QTD_TOTAL,round(sum(bytes)/1024/1024) MB_TOTAL
from dba_segments where owner='&1'
;
select 'ALTER '||segment_type||' '||owner||'.'||segment_name||' STORAGE (MAXEXTENTS UNLIMITED);'
from dba_segments
where owner='&OWNER'
and max_extents - extents < 500;
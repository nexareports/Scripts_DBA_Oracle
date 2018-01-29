select 'ALTER ' ||segment_type||' '||segment_name||' storage (maxextents unlimited);'
from user_segments

select * from user_segments
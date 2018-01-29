--set lines 250
--set pages 1000

select 
   owner,
   segment_name,
   segment_type
from 
   dba_extents
where 
   file_id = &1
and 
  &2 between block_id and block_id + blocks -1;  
  
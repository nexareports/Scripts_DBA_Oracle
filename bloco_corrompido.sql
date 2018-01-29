set pages 1000
set lines 250

select segment_name
from dba_extents
where file_id = &File_ID_
and &N_Bloco between block_id and block_id + blocks;


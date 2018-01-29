col SEGMENT_NAME for a30
col TABLESPACE_NAME for a15

select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME
from user_segments
where segment_name='&Segmento';

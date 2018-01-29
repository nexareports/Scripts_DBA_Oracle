
Prompt Resumo:
SELECT   dfsc.tablespace_name tablespace_name,
         DECODE (
            dfsc.percent_extents_coalesced,
            100,
            (DECODE (
                GREATEST ((SELECT COUNT (1)
                             FROM dba_free_space dfs
                            WHERE dfs.tablespace_name = dfsc.tablespace_name), 1),
                1,
                'No Frag',
                'Bubble Frag'
             )
            ),
            'Possible Honey Comb Frag'
         )
               fragmentation_status
    FROM dba_free_space_coalesced dfsc
ORDER BY dfsc.tablespace_name
/

col segment_name format a30
col owner format a15
Select * from (
Select	owner,
	segment_name,
	count(*) qtd_extents,
	round(sum(bytes)/1024/1024) size_in_mb
from	dba_extents
where owner not in ('SYSTEM','SYS','PERFSTAT')
group by owner,
	segment_name
order by 3 desc)
where rownum<21
order by 3 desc
/


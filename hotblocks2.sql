--hot blocks
select *
from   (select o.owner,
               o.object_name,
               o.subobject_name,
               o.object_type,
               bh.tch,
               bh.obj,
               bh.file#,
               bh.dbablk,
               decode(bh.class,1,'data block',
                               2,'sort block',
                               3,'save undo block',
                               4,'segment header',
                               5,'save undo header',
                               6,'free list',
                               7,'extent map',
                               8,'1st level bmb',
                               9,'2nd level bmb',
                               10,'3rd level bmb',
                               11,'bitmap block',
                               12,'bitmap index block',
                               13,'file header block',
                               14,'unused',
                               15,'system undo header',
                               16,'system undo block',
                               17,'undo header',
                               18,'undo block') as class,
               decode(bh.state, 0,'free',
                                1,'xcur',
                                2,'scur',
                                3,'cr',
                                4,'read',
                                5,'mrec',
                                6,'irec',
                                7,'write',
                                8,'pi',
                                9,'memory',
                                10,'mwrite',
                                11,'donated') as state
        from   v$bh bh,
               dba_objects o
        where  o.data_object_id = bh.obj
        and    bh.addr in  (select addr
                          from   (select name,
                                         addr,
                                         gets,
                                         misses,
                                         sleeps
                                         from   v$latch_children
                                         where  name = 'cache buffers chains'
                                         and    misses > 0
                                         order by misses desc)
                                         ))
where  rownum < 11;


SELECT   i.owner, i.table_name, i.index_name, I.UNIQUENESS, c.constraint_name, c.constraint_type
  FROM   dba_indexes i, dba_constraints c
 WHERE   i.owner like 'SDGEO%' AND I.UNIQUENESS !='UNIQUE'
 and c.owner=i.owner
 and c.table_name=i.table_name
 and C.CONSTRAINT_NAME=i.index_name
 and c.constraint_type in ('U','P');
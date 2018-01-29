drop sequence rdeptree_seq
/
create sequence rdeptree_seq cache 200 /* cache 200 to make sequence faster */
/
drop table rdeptree_temptab
/
create table rdeptree_temptab
(
  object_id            number,
  referenced_object_id number,
  nest_level           number,
  seq#                 number      
)
/
create or replace procedure rdeptree_fill (type char, schema char, name char) is
  obj_id number;
begin
  delete from rdeptree_temptab;
  commit;
  select object_id into obj_id from all_objects
    where owner        = upper(rdeptree_fill.schema)
    and   object_name  = upper(rdeptree_fill.name)
    and   object_type  = upper(rdeptree_fill.type);
  insert into rdeptree_temptab
    values(0, obj_id, 0, 0);
  insert into rdeptree_temptab
    select object_id, referenced_object_id,
        level, rdeptree_seq.nextval
      from public_dependency
      connect by object_id = prior referenced_object_id
      start with object_id = rdeptree_fill.obj_id;
exception
  when no_data_found then
    raise_application_error(-20000, 'ORU-10013: ' ||
      type || ' ' || schema || '.' || name || ' was not found.');
end;
/

drop view rdeptree
/

set echo on

set echo off
create view rdeptree
  (nested_level, type, schema, name, seq#)
as
  select d.nest_level, o.object_type, o.owner, o.object_name, d.seq#
  from rdeptree_temptab d, all_objects o
  where d.referenced_object_id = o.object_id (+)
/

drop view irdeptree
/
create view irdeptree (dependencies)
as
  select lpad(' ',3*(max(nested_level))) || max(nvl(type, '<no permission>')
    || ' ' || schema || decode(type, NULL, '', '.') || name)
  from rdeptree
  group by seq# /* So user can omit sort-by when selecting from ideptree */
/
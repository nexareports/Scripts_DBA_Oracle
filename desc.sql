/*

Created: Version 1: 01/30/2012 Jed S. Walker
Updated: Version 2: 03/20/2006 Jed S. Walker

Notes :
       does not work on Oracle <9i due to Mview check
To do:
       does not handle "" table names 
Usage:
       @jdesc user.table 
       @jdesc table
*/

set serveroutput on size 1000000

set verify off
set feedback off

set pages 50 linesize 120
set long 10000

col owner format a20
col object_name format a35

declare
  n_exist        number;
  v_param1       varchar2(200);
  v_seploc       number;
  v_schema_name  user_tables.table_name%type;
  v_table_name   user_tables.table_name%type;
  v_longmsg      varchar2(4000);
  v_type_atts    varchar2(500);
  cursor curs_syns (owner_val varchar2, tabname_val varchar2) 
  is select owner, synonym_name
     from all_synonyms
     where owner = owner_val
     and table_name = tabname_val
     order by owner, synonym_name;
  cursor curs_tcols (owner_val varchar2, tabname_val varchar2) 
  is select column_name, data_type, 
            data_length, data_precision, data_scale,
            decode(nullable,'Y','NULL','NOT NULL') nullable, 
            data_default
     from all_tab_columns
     where owner = owner_val
     and table_name = tabname_val
     order by column_id;
  v_lenprec  varchar2(20);
  cursor curs_cons (owner_val varchar2, tabname_val varchar2)
  is select constraint_name, 
            decode(constraint_type, 'P', 'Primary', 'U', 'Unique',
                                    'C', 'Check', 'R', 'References', constraint_type)
                  constraint_type, 
            search_condition, r_constraint_name, 
            decode(delete_rule, 'NO ACTION', '', delete_rule) delete_rule,
            decode(constraint_type, 'P', 1, 'U', 2, 'R', 3, 'C', 4, 5) sortorder
     from all_constraints
     where owner = owner_val
     and table_name = tabname_val
     order by sortorder, constraint_name;
  v_fk_table_name   user_tables.table_name%type;
  v_temp            varchar2(2000);
  cursor curs_ccollist (owner_val varchar2, consname_val varchar2)
  is select column_name
     from all_cons_columns
     where owner = owner_val
     and constraint_name = consname_val
     order by position;
  v_criteria   varchar2(2000);
  cursor curs_inds (owner_val varchar2, tabname_val varchar2)
  is select index_name, index_type, uniqueness 
     from all_indexes
     where owner = owner_val
     and table_name = tabname_val
     order by uniqueness desc, index_name;
  cursor curs_icollist (owner_val varchar2, indname_val varchar2)
  is select column_name
     from all_ind_columns
     where index_owner = owner_val
     and index_name = indname_val
     order by column_position;
  v_columns   varchar2(2000);
  cursor curs_trigs (owner_val varchar2, tabname_val varchar2) 
  is select trigger_name, trigger_type, triggering_event
     from all_triggers
     where owner = owner_val
     and table_name = tabname_val
     order by trigger_type, triggering_event, trigger_name;
begin

  -- get parameters and determine if this is local schema or other schema 
  v_param1:='&1';
  v_seploc:=instr(v_param1,'.');
  if v_seploc = 0 then
    v_schema_name:=upper(SYS_CONTEXT('USERENV','CURRENT_SCHEMA'));
    v_table_name:=upper(v_param1);
  else
    v_schema_name:=upper(substr(v_param1,1,v_seploc-1));
    v_table_name:=upper(substr(v_param1,v_seploc+1,length(v_param1)-v_seploc));
  end if;

  -- check for table existence or view
  select count(1) into n_exist
  from all_tables
  where owner = v_schema_name
  and table_name = v_table_name;
  if n_exist = 0 then
    select count(1) into n_exist
    from all_views
    where owner = v_schema_name
    and view_name = v_table_name;
    if n_exist = 0 then
      dbms_output.put_line('Table ' || v_schema_name || '.' || v_table_name || ' does not exist');
    else
      dbms_output.put_line(chr(10) || v_schema_name || '.' || v_table_name || ' is a view:' || chr(10));
      select text into v_longmsg from all_views where owner = v_schema_name and view_name = v_table_name; 
      dbms_output.put_line(v_longmsg);
    end if;
  else

    -- show table name and type attributes
    dbms_output.put_line(chr(10) || v_schema_name || '.' || v_table_name || chr(10));
    -- show table type attributes
    select decode(temporary,'Y','YES','N','NO') into v_temp
    from all_tables
    where owner = v_schema_name
    and table_name = v_table_name;
    dbms_output.put_line('Temporary Table => ' || v_temp);
    select decode(iot_type,'IOT','YES','NO') into v_temp
    from all_tables
    where owner = v_schema_name
    and table_name = v_table_name;
    dbms_output.put_line('Index Organized Table (IOT) => ' || v_temp);
    select partitioned into v_temp 
    from all_tables
    where owner = v_schema_name
    and table_name = v_table_name;
    dbms_output.put_line('Partitioned => ' || v_temp);
    select decode(cluster_name,null,'NO','YES') into v_temp
    from all_tables
    where owner = v_schema_name
    and table_name = v_table_name;
    dbms_output.put_line('Clustered Table => ' || v_temp);
    select decode(compression,'ENABLED','YES','NO') into v_temp
    from all_tables
    where owner = v_schema_name
    and table_name = v_table_name;
    dbms_output.put_line('Compressed Table => ' || v_temp);
    select decode(count(1),0,'NO','YES') into v_temp
    from all_base_table_mviews
    where owner = v_schema_name
    and master = v_table_name;
    dbms_output.put_line('Materialized Views => ' || v_temp);
    select decode(count(1),0,'NO','YES') into v_temp
    from all_policies
    where object_owner = v_schema_name
    and object_name = v_table_name;
    dbms_output.put_line('Fine Grained Access Control => ' || v_temp);

    -- show synonyms
    dbms_output.put_line(chr(10));
    n_exist:=0;
    for rec_syn in curs_syns (v_schema_name,v_table_name) loop
      dbms_output.put_line('Synonym: ' || rec_syn.owner || ' : ' || rec_syn.synonym_name);
      n_exist:=n_exist+1;
    end loop;
    if n_exist = 0 then
      dbms_output.put_line('There are no synonyms for this table.');
    end if;

    -- list columns, data type, null?, default
    dbms_output.put_line(chr(10) || rpad('COLUMN',32) || chr(9) ||
                                    rpad('TYPE',14) || chr(9) ||
                                    rpad('NULLS',10) || chr(9) ||
                                    'DEFAULT');
    dbms_output.put_line(rpad('------',32) || chr(9) ||
                         rpad('----',14) || chr(9) ||
                         rpad('-----',10) || chr(9) ||
                         '-------');
    for rec_col in curs_tcols (v_schema_name,v_table_name) loop
      if rec_col.data_type in ('CHAR','VARCHAR2','NCHAR','NVARCHAR2') then
        v_lenprec:='(' || rec_col.data_length || ')';
      elsif rec_col.data_type in ('NUMBER') then
        v_lenprec:='(' || rec_col.data_precision || ',' || rec_col.data_scale || ')';
      else
        v_lenprec:='';
      end if;
      dbms_output.put_line(rpad(rec_col.column_name,32) || chr(9) || 
                           rpad(rec_col.data_type || v_lenprec,14) || chr(9) ||
                           rpad(rec_col.nullable,10) || chr(9) ||
                           rec_col.data_default);
    end loop;

    -- constraints
    dbms_output.put_line(chr(10) || rpad('CONSTRAINT',32) || chr(9) ||
                                    rpad('TYPE',14) || chr(9) ||
                                    'CRITERIA');
    dbms_output.put_line(rpad('----------',32) || chr(9) ||
                         rpad('----',14) || chr(9) ||
                         '--------');
    n_exist:=0;
    for rec_con in curs_cons (v_schema_name,v_table_name) loop
      if rec_con.constraint_type in ('Primary','Unique') then
        v_criteria:='(';
        for rec_collist in curs_ccollist(v_schema_name,rec_con.constraint_name) loop
          if v_criteria != '(' then 
            v_criteria:=v_criteria||','; 
          end if;
          v_criteria:=v_criteria || rec_collist.column_name; 
        end loop;
        v_criteria:=v_criteria || ')';
      elsif rec_con.constraint_type = 'References' then
        --v_criteria:=rec_con.r_constraint_name;
        select table_name into v_fk_table_name
        from all_constraints
        where owner = v_schema_name
        and constraint_name = rec_con.r_constraint_name;
        v_temp:='(';
        for rec_collist in curs_ccollist(v_schema_name,rec_con.r_constraint_name) loop
          if v_temp != '(' then 
            v_temp:=v_temp||','; 
          end if;
          v_temp:=v_temp || rec_collist.column_name; 
        end loop;
        v_temp:=v_temp || ')';
        v_criteria:=v_fk_table_name || v_temp || ' ' || rec_con.delete_rule;
      elsif rec_con.constraint_type = 'Check' then
        v_criteria:=rec_con.search_condition;
        if length(v_criteria) > (250-32-14) then
          v_criteria:=substr(v_criteria,1,(250-32-14)) || '...';
        end if;
      else
        v_criteria:='Unknown';
      end if;
      n_exist:=n_exist+1;
      dbms_output.put_line(rpad(rec_con.constraint_name,32) || chr(9) || 
                           rpad(rec_con.constraint_type,14) || chr(9) ||
                           v_criteria);
    end loop;
    if n_exist = 0 then
      dbms_output.put_line('<none>');
    end if;

    -- indexes
    dbms_output.put_line(chr(10) || rpad('INDEX',32) || chr(9) ||
                                    rpad('TYPE',20) || chr(9) ||
                                    'COLUMNS');
    dbms_output.put_line(rpad('-----',32) || chr(9) ||
                         rpad('----',20) || chr(9) ||
                         '-------');
    n_exist:=0;
    for rec_ind in curs_inds (v_schema_name,v_table_name) loop
      v_columns:='(';
      for rec_collist in curs_icollist (v_schema_name,rec_ind.index_name) loop
          if v_columns != '(' then 
            v_columns:=v_columns||','; 
          end if;
          v_columns:=v_columns || rec_collist.column_name; 
        end loop;
        v_columns:=v_columns || ')';
      dbms_output.put_line(rpad(rec_ind.index_name,32) || chr(9) || 
                           rpad(rec_ind.uniqueness || ':' || rec_ind.index_type,20) || chr(9) ||
                           v_columns);
      n_exist:=n_exist+1;
    end loop;
    if n_exist = 0 then
      dbms_output.put_line('<none>');
    end if;

    -- triggers
    dbms_output.put_line(chr(10) || rpad('TRIGGER',32) || chr(9) ||
                                    rpad('TYPE',20) || chr(9) ||
                                    rpad('EVENT',20) );
    dbms_output.put_line(rpad('-----',32) || chr(9) ||
                         rpad('----',20) || chr(9) ||
                         rpad('------',20) );
    n_exist:=0;
    for rec_trig in curs_trigs (v_schema_name,v_table_name) loop
      dbms_output.put_line(rpad(rec_trig.trigger_name,32) || chr(9) || 
                           rpad(rec_trig.trigger_type,20) || chr(9) ||
                           rpad(rec_trig.triggering_event,20) );
      n_exist:=n_exist+1;
    end loop;
    if n_exist = 0 then
      dbms_output.put_line('<none>');
    end if;

    -- some space before prompt
    dbms_output.put_line(chr(10));

  end if; -- check for table
end;
/

set feedback on
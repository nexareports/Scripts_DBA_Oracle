
 
drop table ckfk_log_moam; 
 
create table ckfk_log_moam ( 
       LineNum number, 
       LineMsg varchar2(2000)); 
 
declare 
t_CONSTRAINT_TYPE            dba_constraints.CONSTRAINT_TYPE%type; 
t_CONSTRAINT_NAME            dba_CONSTRAINTS.CONSTRAINT_NAME%type; 
t_TABLE_NAME                 dba_CONSTRAINTS.TABLE_NAME%type; 
t_R_CONSTRAINT_NAME          dba_CONSTRAINTS.R_CONSTRAINT_NAME%type; 
tt_CONSTRAINT_NAME           dba_CONS_COLUMNS.CONSTRAINT_NAME%type; 
tt_TABLE_NAME                dba_CONS_COLUMNS.TABLE_NAME%type; 
tt_COLUMN_NAME               dba_CONS_COLUMNS.COLUMN_NAME%type; 
tt_POSITION                  dba_CONS_COLUMNS.POSITION%type; 
tt_Dummy                     number; 
tt_dummyChar                 varchar2(2000); 
l_Cons_Found_Flag            VarChar2(1); 
Err_TABLE_NAME               dba_CONSTRAINTS.TABLE_NAME%type; 
Err_COLUMN_NAME              dba_CONS_COLUMNS.COLUMN_NAME%type; 
Err_POSITION                 dba_CONS_COLUMNS.POSITION%type; 
 
tLineNum number; 
 
cursor UserTabs is 
       select table_name 
       from   dba_tables where OWNER='&1'
       order by table_name; 
 
cursor TableCons is 
       select CONSTRAINT_TYPE, 
              CONSTRAINT_NAME, 
              R_CONSTRAINT_NAME 
       from dba_constraints 
       where OWNER='&1'
       and table_name = t_Table_Name 
       and CONSTRAINT_TYPE  = 'R' 
       order by TABLE_NAME, CONSTRAINT_NAME; 
 
cursor ConColumns is 
       select CONSTRAINT_NAME, 
              TABLE_NAME, 
              COLUMN_NAME, 
              POSITION 
       from dba_cons_columns 
       where OWNER='&1'
       and   CONSTRAINT_NAME = t_CONSTRAINT_NAME 
       order by POSITION; 
 
cursor IndexColumns is 
       select TABLE_NAME, 
              COLUMN_NAME, 
              POSITION 
       from dba_cons_columns 
       where OWNER='&1'
       and   CONSTRAINT_NAME = t_CONSTRAINT_NAME 
       order by POSITION; 
 
DebugLevel number := 99; -- >> 99 = dump all info` 
DebugFlag varchar(1) := 'N'; -- Turn Debugging on 
t_Error_Found  varchar(1); 
 
begin 
 
  tLineNum := 1000; 
  open UserTabs; 
  LOOP 
    Fetch UserTabs into t_TABLE_NAME; 
    t_Error_Found := 'N'; 
    exit when UserTabs%NOTFOUND; 
 
    -- Log current table 
    tLineNum := tLineNum + 1; 
    insert into ckfk_log_moam ( LineNum, LineMsg ) values 
    ( tLineNum, NULL ); 
 
    tLineNum := tLineNum + 1; 
    insert into ckfk_log_moam ( LineNum, LineMsg ) values 
    ( tLineNum, 'Checking Table '||t_Table_Name); 
 
    l_Cons_Found_Flag := 'N'; 
    open TableCons; 
    LOOP 
      FETCH TableCons INTO t_CONSTRAINT_TYPE, 
                    t_CONSTRAINT_NAME, 
               t_R_CONSTRAINT_NAME; 
      exit when TableCons%NOTFOUND; 
 
      if ( DebugFlag = 'Y' and DebugLevel >= 99 ) 
      then 
        begin 
          tLineNum := tLineNum + 1; 
          insert into ckfk_log_moam ( LineNum, LineMsg ) values 
          ( tLineNum, 'Found CONSTRAINT_NAME = '|| t_CONSTRAINT_NAME); 
 
          tLineNum := tLineNum + 1; 
          insert into ckfk_log_moam ( LineNum, LineMsg ) values 
          ( tLineNum, 'Found CONSTRAINT_TYPE = '|| t_CONSTRAINT_TYPE); 
 
          tLineNum := tLineNum + 1; 
          insert into ckfk_log_moam ( LineNum, LineMsg ) values 
          ( tLineNum, 'Found R_CONSTRAINT_NAME = '|| t_R_CONSTRAINT_NAME); 
          commit; 
        end; 
      end if; 
 
      open ConColumns; 
      LOOP 
        FETCH ConColumns INTO 
                          tt_CONSTRAINT_NAME, 
                          tt_TABLE_NAME, 
                          tt_COLUMN_NAME, 
                          tt_POSITION; 
        exit when ConColumns%NOTFOUND; 
        if ( DebugFlag = 'Y' and DebugLevel >= 99 ) 
        then 
          begin 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, NULL ); 
 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, 'Found CONSTRAINT_NAME = '|| tt_CONSTRAINT_NAME); 
 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, 'Found TABLE_NAME = '|| tt_TABLE_NAME); 
 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, 'Found COLUMN_NAME = '|| tt_COLUMN_NAME); 
 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, 'Found POSITION = '|| tt_POSITION); 
          commit; 
          end; 
      end if; 
 
      begin 
        select 1 into tt_Dummy 
        from dba_ind_columns 
        where   TABLE_NAME =  tt_TABLE_NAME and index_owner='&1'
        and     COLUMN_NAME = tt_COLUMN_NAME 
        and     COLUMN_POSITION = tt_POSITION; 
 
        if ( DebugFlag = 'Y' and DebugLevel >= 99 ) 
        then 
        begin 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, 'Row Has matching Index' ); 
        end; 
        end if; 
      exception 
      when Too_Many_Rows then 
      if ( DebugFlag = 'Y' and DebugLevel >= 99 ) 
        then 
          begin 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, 'Row Has matching Index' ); 
          end; 
        end if; 
 
      when no_data_found then 
        if ( DebugFlag = 'Y' and DebugLevel >= 99 ) 
        then 
          begin 
            tLineNum := tLineNum + 1; 
            insert into ckfk_log_moam ( LineNum, LineMsg ) values 
            ( tLineNum, 'NO MATCH FOUND' ); 
          commit; 
          end; 
        end if; 
 
        t_Error_Found := 'Y'; 
 
        select distinct TABLE_NAME 
        into tt_dummyChar 
        from dba_cons_columns 
        where owner='&1'
        and   CONSTRAINT_NAME = t_R_CONSTRAINT_NAME; 
 
        tLineNum := tLineNum + 1;
        insert into ckfk_log_moam ( LineNum, LineMsg ) values
        ( tLineNum, 'Changing data in table '||tt_dummyChar
                    ||' will lock table ' ||tt_TABLE_NAME);

        commit; 
        tLineNum := tLineNum + 1; 
        insert into ckfk_log_moam ( LineNum, LineMsg ) values
        ( tLineNum,'Create an index on table '||tt_TABLE_NAME
                   ||' with the following columns to remove lock problem');
        
        open IndexColumns ; 
        loop 
          Fetch IndexColumns into Err_TABLE_NAME, 
              Err_COLUMN_NAME, 
              Err_POSITION; 
          exit when IndexColumns%NotFound; 
          tLineNum := tLineNum + 1; 
          insert into ckfk_log_moam ( LineNum, LineMsg ) values 
          ( tLineNum,'Column = '||Err_COLUMN_NAME||' ('||Err_POSITION||')'); 
        end loop; 
        close IndexColumns; 
      end; 
    end loop; 
    commit; 
  close ConColumns; 
  end loop; 
  if ( t_Error_Found = 'N' ) 
  then 
    begin 
      tLineNum := tLineNum + 1; 
      insert into ckfk_log_moam ( LineNum, LineMsg ) values 
      ( tLineNum,'No foreign key errors found'); 
    end; 
  end if; 
  commit; 
  close TableCons; 
end loop; 
commit; 
end; 
/ 
 


spool c:\tmp\&1.__fk_issues.txt
-----SELECT: Output Final 
Prompt Utilizador: &1
select LineMsg
from ckfk_log_moam
where LineMsg NOT LIKE 'Checking%' AND
      LineMsg NOT LIKE 'No foreign key%'
order by LineNum
/

spool off

drop table ckfk_log_moam; 

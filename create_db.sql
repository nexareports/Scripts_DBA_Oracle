set head off
set termout off
set feedback off
set serveroutput on 

select 'CREATE DATABASE '||name text from v$database;
-- select 'CONTROLFILE REUSE' from dual;  -- optional
select 'LOGFILE' from dual;
declare
    print_var varchar2(200);
    cursor c1 is select member from gv$logfile where inst_id = 1
    order by group#;
    logfile gv$logfile.member%TYPE;
    cursor c2 is select bytes from gv$log where inst_id = 1
    order by group#;
    bytes number;
    lsize varchar2(30);    
begin
    open c1;
    open c2;
    for record in (
    select group#, count(*) members from gv$logfile where inst_id = 1
    group by group#) loop
         dbms_output.put_line(print_var);
         fetch c2 into bytes;
         if mod(bytes,1024) = 0 then
            if mod(bytes,1024*1024) = 0 then
               lsize := to_char(bytes/(1024*1024))||'M';
            else
               lsize := to_char(bytes/1024)||'K';
            end if;
         else
            lsize := to_char(bytes);
         end if;
         lsize := lsize||',';
         if record.members > 1 then
           fetch c1 into logfile;
           print_var := 'GROUP '||record.group#||' (';
           dbms_output.put_line(print_var);
           print_var := ''''||logfile||''''||',';
           for i in 2..record.members loop  
               fetch c1 into logfile;
               dbms_output.put_line(print_var);
               print_var := ''''||logfile||''''||',';
           end loop;
           print_var := rtrim(print_var,',');
           dbms_output.put_line(print_var);
           print_var := ') SIZE '||lsize;
         else
           fetch c1 into logfile;
           print_var := 'GROUP '||record.group#||' '''||
                        logfile||''''||' SIZE '||lsize;
         end if;
    end loop;
    close c1;
    close c2;
    print_var := rtrim(print_var,',');
    dbms_output.put_line(print_var);
end;
/
select 'MAXLOGFILES '||RECORDS_TOTAL from v$controlfile_record_section
        where type = 'REDO LOG';
select 'MAXLOGMEMBERS '||dimlm from sys.x$kccdi;
select 'MAXDATAFILES '||RECORDS_TOTAL from v$controlfile_record_section
        where type = 'DATAFILE';
select 'MAXINSTANCES '||RECORDS_TOTAL from v$controlfile_record_section
        where type = 'DATABASE';
select 'MAXLOGHISTORY '||RECORDS_TOTAL from v$controlfile_record_section
        where type = 'LOG HISTORY'; 
select log_mode from v$database;
select 'CHARACTER SET '||value from v$nls_parameters
     where parameter = 'NLS_CHARACTERSET';
select 'NATIONAL CHARACTER SET '||value from v$nls_parameters
     where parameter = 'NLS_NCHAR_CHARACTERSET';          
select 'DATAFILE' from dual;
declare
   cursor c1 is select * from dba_data_files
   where tablespace_name = 'SYSTEM'  order by file_id;
   datafile dba_data_files%ROWTYPE;
   print_datafile dba_data_files.file_name%TYPE;
begin
   open c1;
   fetch c1 into datafile;
   -- there is always 1 datafile
   print_datafile := ''''||datafile.file_name||
   ''' SIZE '||ceil(datafile.bytes/(1024*1024))||' M,';
   loop
        fetch c1 into datafile;
        if c1%NOTFOUND then
           -- strip the comma and print the last datafile
           print_datafile := rtrim(print_datafile,',');
           dbms_output.put_line(print_datafile);
           exit;
        else
            -- print the previous datafile and prepare the next
            dbms_output.put_line(print_datafile);
            print_datafile := ''''||datafile.file_name||
            ''' SIZE '||ceil(datafile.bytes/(1024*1024))||' M,';
        end if;
   end loop;     
end;
/             
select ';' from dual;

set head on
set termout on
set feedback on

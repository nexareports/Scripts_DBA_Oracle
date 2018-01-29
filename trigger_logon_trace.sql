grant alter session to REPSQL;

create or replace TRIGGER REPSQL.LOGON_TRC 
AFTER LOGON
ON REPSQL.SCHEMA
begin
execute immediate 'alter session set tracefile_identifier = ''' || user ||'_'|| to_char(sysdate,'YYYYMMDDHH24MISS')||'''';
execute immediate 'alter session set events = ''10046 trace name context forever, level 12''';
end;
/


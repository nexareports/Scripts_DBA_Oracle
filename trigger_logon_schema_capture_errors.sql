create or replace trigger PPTESTES_TRACE after logon on PPTESTES.schema
begin
execute immediate 'ALTER SESSION SET sql_trace = true';
execute immediate 'ALTER SESSION SET events ''10046 trace name context forever, level 12''';
execute immediate 'ALTER SESSION SET tracefile_identifier = ''trace_PPTESTES''';
end;
/


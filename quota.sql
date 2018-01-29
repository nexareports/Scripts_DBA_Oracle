set serveroutput on
set feedback off
exec dbms_output.put_line('======================================');
exec dbms_output.put_line('Tipos: unlimited ou tamanho em M {MB}');
exec dbms_output.put_line('======================================');
set feedback on
alter user &user_ quota &quota_ on &tablespace_;
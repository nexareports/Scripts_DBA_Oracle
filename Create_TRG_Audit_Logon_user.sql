create table &1.user_logon_audit
(
   username              varchar2(100),
   host              varchar2(100),
   logon_day                 date
);

grant insert,select,update on &1.user_logon_audit to public;
 

 

create or replace trigger logon_audit_trigger
after logon on database
Declare
	cont     number;
begin
select count(*) into cont from daa.user_logon_audit where username=user;
if cont = 0 then
            insert into &1.user_logon_audit values(
               user,
               sys_context('USERENV','HOST'),
               sysdate);
else
            update daa.user_logon_audit set logon_day=sysdate, host=sys_context('USERENV','HOST') where username=user;
end if;
end;
/



alter session set nls_date_format='DD-MM-YYYY HH24:MI:SS';
select * from &1.user_logon_audit;


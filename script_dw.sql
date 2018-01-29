
column filename new_val filename
select 'DB_'||instance_name||'.sql' filename from v$instance;
spool &filename

SET LINES 1000
SET PAGES 10000
SET LONGCHUNKSIZE 1000000
SET TRIM ON
SET HEAD OFF
SET TRIMSPOOL ON
SET ECHO OFF
SET LONG 20000000 
SET FEEDBACK OFF

spool &filename


--Profiles
Select '-- #############  Profiles #############' from dual;
Select unique 
'select dbms_metadata.get_ddl('||chr(39)||'PROFILE'||chr(39)||','||chr(39)||profile||chr(39)||')||'||chr(39)||';'||chr(39)||' from dual;' 
from dba_profiles where profile like 'PROF%';


--Roles
Select '-- #############  Roles #############' from dual;
Select unique 
'select dbms_metadata.get_ddl('||chr(39)||'ROLE'||chr(39)||','||chr(39)||role||chr(39)||')||'||chr(39)||';'||chr(39)||' from dual;' 
from dba_roles where role like 'RL_%';


--Tablespaces
Select '-- #############  Tablespaces #############' from dual;
with tb as (
Select  
'create tablespace '||tablespace_name||' datafile '||chr(39)||'+DATA'||chr(39)||' size '  tbs, sum(bytes)/1024/1024 MB 
from dba_data_files where tablespace_name not in ('SYSTEM','SYSAUX','UNDOTBS','UNDOTBS1')
group by 'create tablespace '||tablespace_name||' datafile '||chr(39)||'+DATA'||chr(39)||' size '  
order by 2 desc)
Select tbs||mb||';' from tb;


--Users
Select '-- #############  Users #############' from dual;
Select
'create user '||replace(username,'OPS$','')||' identified by values '||chr(39)||b.password||chr(39)||' profile '||profile||' default tablespace '||default_tablespace||' temporary tablespace '||temporary_tablespace||';'
from dba_users a, sys.user$ b 
where 
a.username=b.name and 
(a.profile not like 'PROF_IBM%' and a.profile not like 'DEFAUL%');


--Privilegios p/Roles
Select '-- #############  Privilesios p/Roles #############' from dual;
Select 'grant '||privilege||' to '||grantee||';' cmd from dba_sys_privs where grantee like 'RL_%'
union all
Select 'grant '||granted_role||' to '||grantee||';' cmd from dba_role_privs where grantee like 'RL_%'
union all
Select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||';' cmd from dba_tab_privs where grantee like 'RL_%' and privilege not in ('READ','WRITE')
union all
Select 'grant '||privilege||' on directory '||owner||'.'||table_name||' to '||grantee||';' cmd from dba_tab_privs where grantee like 'RL_%' and privilege  in ('READ','WRITE');

--Privilegios p/Users
Select '-- #############  Privilegios p/Users #############' from dual;
with usr as (select username from dba_users where profile not like 'PROF_IBM%' and profile not like 'DEFAUL%')
Select 'grant '||privilege||' to '||grantee||';' cmd from dba_sys_privs, usr where username=grantee
union all
Select 'grant '||granted_role||' to '||grantee||';' cmd from dba_role_privs, usr where username=grantee
union all
Select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||';' cmd from dba_tab_privs, usr where username=grantee and privilege not in ('READ','WRITE')
union all
Select 'grant '||privilege||' on directory '||owner||'.'||table_name||' to '||grantee||';' cmd from dba_tab_privs, usr where username=grantee and privilege  in ('READ','WRITE');

--DbLinks
Select '-- #############  DBLink #############' from dual;
SELECT 'CREATE '
|| DECODE (U.NAME, 'PUBLIC', 'PUBLIC ')
|| 'DATABASE LINK "'
|| DECODE (U.NAME, 'PUBLIC', NULL, U.NAME ||'.')
|| L.NAME
|| '" CONNECT TO "'
|| L.USERID
|| '" IDENTIFIED BY VALUES "'
|| L.PASSWORDX
|| '" USING "'
|| L.HOST
|| '"'
|| ';' 
CMD
FROM sys.link$ L, sys.user$ U
WHERE L.OWNER# = U.USER#;


spool off


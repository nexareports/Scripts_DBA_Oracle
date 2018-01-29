-- Create roles
select 'CREATE ROLE ROLE_'||username||'_ALL;'||chr(10)||'CREATE ROLE ROLE_'||username||'_READ;'
from dba_users
where username in ('PCRTABLES','SPDITABLES','CGDTABLES','PTSMTABLES','SCPTABLES');

-- privilegios all às tabelas
select 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||owner||'.'||table_name||' TO ROLE_'||owner||'_ALL;' 
from dba_tables
where owner in ('PCRTABLES','SPDITABLES','CGDTABLES','PTSMTABLES','SCPTABLES')
union all
select 'GRANT SELECT ON '||owner||'.'||object_name||' TO ROLE_'||owner||'_ALL;' 
from dba_objects
where owner in ('PCRTABLES','SPDITABLES','CGDTABLES','PTSMTABLES','SCPTABLES')
and object_type in ('VIEW','SEQUENCE')
union all
select 'GRANT EXECUTE ON '||owner||'.'||object_name||' TO ROLE_'||owner||'_ALL;' 
from dba_objects
where owner in ('PCRTABLES','SPDITABLES','CGDTABLES','PTSMTABLES','SCPTABLES')
and object_type in ('PROCEDURE','PACKAGE','FUNCTION');

--privilégios de leitura à role READ
select 'GRANT SELECT ON '||owner||'.'||object_name||' TO ROLE_'||owner||'_READ;' 
from dba_objects
where owner in ('PCRTABLES','SPDITABLES','CGDTABLES','PTSMTABLES','SCPTABLES')
and object_type in ('TABLE','VIEW');
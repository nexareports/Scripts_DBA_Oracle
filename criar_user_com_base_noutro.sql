declare
    util_criar varchar2(20) := 'C015832';
    util_ref varchar2(20) := 'C010460';
    v_defrole varchar2(30);
    v_adminoption varchar2(200);
    v_str varchar2(2000);
begin
       for reg in (
           select username, default_tablespace, profile
          from dba_users
         where username = util_ref
        )
       loop
           v_str := 'CREATE USER '||util_criar||' IDENTIFIED BY cgd#1234 DEFAULT TABLESPACE '||reg.default_tablespace||' PROFILE '||reg.profile||' ACCOUNT UNLOCK PASSWORD EXPIRE;';
    end loop;
    dbms_output.put_line(v_str);
    
    for reg in (
           select distinct granted_role, admin_option
         from dba_role_privs
         where grantee = util_ref
        )
       loop
        if reg.admin_option = 'YES' then
            v_adminoption := 'WITH ADMIN OPTION;';
        else
            v_adminoption := ';';
        end if;
           v_str := 'GRANT '||reg.granted_role||' TO '||util_criar||' '||v_adminoption;
        dbms_output.put_line(v_str);
    end loop;
    
    for reg in (
           select privilege, admin_option
          from dba_sys_privs
         where grantee = util_ref
        )
       loop
        if reg.admin_option = 'YES' then
            v_adminoption := 'WITH ADMIN OPTION;';
        else
            v_adminoption := ';';
        end if;
           v_str := 'GRANT '||reg.privilege||' TO '||util_criar||' '||v_adminoption;
    end loop;
    dbms_output.put_line(v_str);
    
    v_str := 'ALTER USER '||util_criar||' DEFAULT ROLE ';
    for reg in (
           select granted_role, default_role
          from dba_role_privs
         where grantee = util_ref
        )
       loop
        
        if reg.default_role = 'YES' then
            v_str := v_str||reg.granted_role||', ';
        end if;
    end loop;
    v_str := substr(v_str, 1, length(v_str)-2);
    v_str := v_str||';';
    dbms_output.put_line(v_str);
end;
/

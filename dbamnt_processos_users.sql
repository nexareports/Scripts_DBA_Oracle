grant select on v_$session to dbamnt;
grant alter user to dbamnt;

CREATE TABLE DBAMNT.DBABES_USERS_EXCEP
(
USERNAME VARCHAR2(30),
FLAG number default 1,
OBS VARCHAR2(200)
);

CREATE TABLE DBAMNT.DBABES_USERS_LOG
(
USERNAME VARCHAR2(30),
OSUSER VARCHAR2(30),
machine VARCHAR2(64),
PROGRAM VARCHAR2(48),
module VARCHAR2(64),
DATA_ACAO DATE DEFAULT SYSDATE,
ACAO VARCHAR2(20),
USER_ALTERADO VARCHAR2(30),
OBS VARCHAR2(200)
);

/*
--Popular a tabela com users de excecao
INSERT INTO DBAMNT.DBABES_USERS_EXCEP
SELECT username, '1',sysdate FROM dba_users
WHERE created < SYSDATE - 200
ORDER BY created DESC;

commit;
*/



CREATE or replace PACKAGE dbamnt.users
AS
PROCEDURE change_password(p_name VARCHAR2, p_password VARCHAR2);
PROCEDURE unlock_user(p_name varchar2);
END;
/


create or replace 
PACKAGE BODY        dbamnt.users
AS
PROCEDURE Change_Password(
    p_Name     VARCHAR2,
    p_Password VARCHAR2 )
IS
  v_user     NUMBER;
  v_username VARCHAR2(30);
  v_OSUSER   VARCHAR2(30);
  v_machine  VARCHAR2(64);
  v_PROGRAM  VARCHAR2(48);
  v_module   VARCHAR2(64);
  vstr       VARCHAR2(500);
BEGIN
  SELECT COUNT(*)
  INTO v_USER
  FROM DBABES_USERS_EXCEP
  WHERE username=upper(p_Name)
  AND flag      =1;
  SELECT username,
    osuser,
    machine,
    PROGRAM,
    module
  INTO v_username,
    v_osuser,
    v_machine,
    v_PROGRAM,
    v_module
  FROM v$session
  WHERE audsid = userenv('sessionid');
  IF v_user    > 0 THEN
    dbms_output.put_line ('Nao tem privilegios para alterar o user '||upper(p_Name));
    INSERT
    INTO DBABES_USERS_LOG VALUES
      (
        v_username,
        v_osuser,
        v_machine,
        v_PROGRAM,
        v_module,
        SYSDATE,
        'CHANGE PASSWORD',
        p_Name,
        'NOK - User de exclusao'
      );
    COMMIT;
  ELSE
    vstr:='ALTER USER '||upper(p_Name)||' IDENTIFIED BY '|| p_password ||' ACCOUNT UNLOCK';
    EXECUTE IMMEDIATE vstr;
    INSERT
    INTO DBABES_USERS_LOG VALUES
      (
        v_username,
        v_osuser,
        v_machine,
        v_PROGRAM,
        v_module,
        SYSDATE,
        'CHANGE PASSWORD',
        p_Name,
        'OK'
      );
    COMMIT;
	dbms_output.put_line ('User '||upper(p_Name)||' alterado');
  END IF;
END;

PROCEDURE Unlock_User(
    p_Name     VARCHAR2 )
IS
  v_user     NUMBER;
  v_username VARCHAR2(30);
  v_OSUSER   VARCHAR2(30);
  v_machine  VARCHAR2(64);
  v_PROGRAM  VARCHAR2(48);
  v_module   VARCHAR2(64);
  vstr       VARCHAR2(500);
BEGIN
  SELECT COUNT(*)
  INTO v_USER
  FROM DBABES_USERS_EXCEP
  WHERE username=upper(p_Name)
  AND flag      =1;
  SELECT username,
    osuser,
    machine,
    PROGRAM,
    module
  INTO v_username,
    v_osuser,
    v_machine,
    v_PROGRAM,
    v_module
  FROM v$session
  WHERE audsid = userenv('sessionid');
  IF v_user    > 0 THEN
    dbms_output.put_line ('Nao tem privilegios para alterar o user '||upper(p_Name));
    INSERT
    INTO DBABES_USERS_LOG VALUES
      (
        v_username,
        v_osuser,
        v_machine,
        v_PROGRAM,
        v_module,
        SYSDATE,
        'UNLOCK USER',
        p_Name,
        'NOK - User de exclusao'
      );
    COMMIT;
  ELSE
    vstr:='ALTER USER '||upper(p_Name)||' ACCOUNT UNLOCK';
    EXECUTE IMMEDIATE vstr;
    INSERT
    INTO DBABES_USERS_LOG VALUES
      (
        v_username,
        v_osuser,
        v_machine,
        v_PROGRAM,
        v_module,
        SYSDATE,
        'UNLOCK USER',
        p_Name,
        'OK'
      );
    COMMIT;
	dbms_output.put_line ('User '||upper(p_Name)||' desbloqueado');
  END IF;
END;

END;
/

/*
--atribuir privilegios e criar sinonimos
grant execute on DBAMNT.users to t00474;
create synonym t00474.users for DBAMNT.users;
*/
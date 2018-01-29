grant select on sys.v_$session to dbamnt;
grant select on sys.v_$process to dbamnt;
grant alter system to dbamnt;

CREATE TABLE DBAMNT.KILLED_SESSIONS
  (
    sid        NUMBER,
    serial#    NUMBER,
    username   VARCHAR2(30),
	spid       VARCHAR2(24),
    osuser     VARCHAR2(30),
    machine    VARCHAR2(64),
    program    VARCHAR2(48),
    module     VARCHAR2(64),
    logon_time DATE,
    kill_time  DATE
  );

CREATE OR REPLACE
PROCEDURE dbamnt.kill_session(
    p_sid     IN VARCHAR2,
    p_serial# IN VARCHAR2)
IS
  cursor_name pls_integer DEFAULT dbms_sql.open_cursor;
  ignore pls_integer;
  CURSOR c_session
  IS
    SELECT a.sid,
      a.serial#,
      a.username,
      a.osuser,
      a.machine,
      a.program,
      a.module,
      a.logon_time,
      b.spid
    FROM V$session a,
      v$process b
    WHERE a.paddr  =b.addr
    AND a.username = USER
    AND a.sid      = p_sid
    AND a.serial#  = p_serial# ;
  c1 c_session%ROWTYPE;
BEGIN
  SELECT COUNT(*)
  INTO ignore
  FROM V$session
  WHERE username = USER
  AND sid        = p_sid
  AND serial#    = p_serial# ;
  IF ( ignore    = 1 ) THEN
    OPEN c_session;
    FETCH c_session INTO c1;
    dbms_sql.parse(cursor_name, 'alter system kill session ''' ||p_sid||','||p_serial#||'''', dbms_sql.native);
    ignore := dbms_sql.execute(cursor_name);
    INSERT
    INTO KILLED_SESSIONS VALUES
      (
        c1.sid,
        c1.serial#,
        c1.username,
        c1.spid,
        c1.osuser,
        c1.machine,
        c1.program,
        c1.module,
        c1.logon_time,
        sysdate
      );
    COMMIT;
  ELSE
    raise_application_error( -20001, 'You do not own session ''' || p_sid || ',' || p_serial# || '''' );
  END IF;
END;
/


create public synonym kill_session for dbamnt.kill_session;
grant execute on dbamnt.kill_session to public;
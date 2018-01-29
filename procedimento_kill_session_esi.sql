grant select on sys.v_$session to dbamnt;
grant alter system to dbamnt;


CREATE OR REPLACE
PROCEDURE dbamnt.kill_session(
    p_sid     IN VARCHAR2,
    p_serial# IN VARCHAR2)
IS
  cursor_name pls_integer DEFAULT dbms_sql.open_cursor;
  ignore pls_integer;
BEGIN
  SELECT COUNT(*)
  INTO ignore
  FROM V$session
  WHERE username = USER
  AND sid        = p_sid
  AND serial#    = p_serial# ;
  IF ( ignore    = 1 ) THEN
    dbms_sql.parse(cursor_name, 'alter system kill session ''' ||p_sid||','||p_serial#||'''', dbms_sql.native);
    ignore := dbms_sql.execute(cursor_name);
  ELSE
    raise_application_error( -20001, 'You do not own session ''' || p_sid || ',' || p_serial# || '''' );
  END IF;
END;
/


create public synonym kill_session for dbamnt.kill_session;
grant execute on dbamnt.kill_session to xxxxx;

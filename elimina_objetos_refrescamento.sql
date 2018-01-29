set serveroutput on

DECLARE
BEGIN
  FOR r1 IN
  (SELECT 'DROP '
    || object_type
    || ' '
    ||owner
    ||'.'
    || object_name
    || DECODE ( OBJECT_TYPE, 'TABLE', ' CASCADE CONSTRAINTS PURGE' )
    --||';' 
    AS v_sql
  FROM dba_objects
  where OBJECT_TYPE in ( 'TABLE', 'VIEW', 'PACKAGE', 'TYPE', 'PROCEDURE', 'FUNCTION', 'TRIGGER', 'SEQUENCE' )
  AND owner          in ('MSGW','SCOTN')
  ORDER BY object_type,
    OBJECT_NAME
  )
  LOOP
    execute immediate R1.V_SQL;
	 --dbms_output.put_line (r1.v_sql);
  END LOOP;
end;
/
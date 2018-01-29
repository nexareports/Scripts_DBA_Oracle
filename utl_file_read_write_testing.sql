DECLARE
vInHandle utl_file.file_type;
vNewLine  VARCHAR2(250);
BEGIN
  vInHandle := utl_file.fopen('INBOX','FVC039.TXT','R');
  LOOP
    BEGIN
      utl_file.get_line(vInHandle, vNewLine);
      dbms_output.put_line(vNewLine);
    EXCEPTION
      WHEN OTHERS THEN
        EXIT;
    END;
  END LOOP;
  utl_file.fclose(vInHandle);
END fopen;
/

DECLARE
vOutHandle utl_file.file_type;
vNewLine  VARCHAR2(250);
BEGIN
  vOutHandle := utl_file.fopen('OUTBOX','teste.out','W');
  LOOP
    BEGIN
      utl_file.putf(vOutHandle, 'teste vs');
    EXCEPTION
      WHEN OTHERS THEN
        EXIT;
    END;
  END LOOP;
  utl_file.fclose(vOutHandle);
END fopen;
/

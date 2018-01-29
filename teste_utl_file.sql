DECLARE
vInHandle utl_file.file_type;
vNewLine  VARCHAR2(250);
BEGIN
  vInHandle := utl_file.fopen('INBOX','telemoveis.txt','R');
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

CREATE OR REPLACE PROCEDURE DROP_TABLES_HARVEST
IS
CURSOR c1 IS
select table_name
from user_tables
where table_name like 'TMP_OBJ_INV_HV%';
str VARCHAR2(120);
BEGIN
for st_c1 in c1 loop
str := 'DROP TABLE '|| st_c1.table_name;
EXECUTE IMMEDIATE str;
dbms_output.put_line(str);
end loop;
END;
/

grant execute on DROP_TABLES_HARVEST to daa;

create synonym daa.DROP_TABLES_HARVEST for DROP_TABLES_HARVEST;
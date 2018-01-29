CREATE OR REPLACE PROCEDURE DWHDBA.cria_particoes
IS
   CURSOR tabs
   IS
        SELECT   table_owner,
                 table_name,
                 'P_'
                 || TO_CHAR (
                       LAST_DAY(NEXT_DAY (
                                   TO_DATE (
                                      SUBSTR (MAX (partition_name), 3, 8),
                                      'yyyymmdd'
                                   ),
                                   +1
                                )),
                       'yyyymmdd'
                    )
                    nome_particao,
                 TO_CHAR (
                    LAST_DAY(NEXT_DAY (
                                TO_DATE (SUBSTR (MAX (partition_name), 3, 8),
                                         'yyyymmdd'),
                                +1
                             ))
                    + 1,
                    'yyyymmdd'
                 )
                    data
          FROM   dba_tab_partitions
         WHERE   table_owner = 'DWHDBA' AND table_name NOT LIKE 'BIN%'
      GROUP BY   table_owner, table_name;

   str   VARCHAR2 (2000);
BEGIN
   FOR tab1 IN tabs
   LOOP
      str :=
            'alter table '
         || tab1.table_owner
         || '.'
         || tab1.table_name
         || ' add partition '
         || tab1.nome_particao
         || ' values less than ('''
         || tab1.data
         || ''') update indexes';
       --execute immediate str;
      DBMS_OUTPUT.PUT_LINE (str);
   END LOOP;
END;
/

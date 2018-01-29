set echo on
set time on
set timing on

TRUNCATE TABLE &&TABELA;

insert into &&TABELA select * from &&TABELA@ORCC8_T1.PT.TELECOM.PT;

COMMIT;
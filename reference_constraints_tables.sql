COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A38 HEADING "References:| Table.Column"
 
SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.TABLE_NAME||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.TABLE_NAME||'.'||ucc2.column_name||')' references_column
FROM     DBA_CONSTRAINTS UC
,        DBA_CONS_COLUMNS UCC1
,        dba_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.POSITION = ucc2.POSITION -- Correction for multiple column primary keys.
AND      UC.CONSTRAINT_TYPE = 'R'
and ucc2.table_name='RECONCILIACAO'
ORDER BY UCC1.TABLE_NAME
,        uc.constraint_name;
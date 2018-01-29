set long 2000000
select sql_fulltext from v$sqlarea where sql_id='&1';
@__conf

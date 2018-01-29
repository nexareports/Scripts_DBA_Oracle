col owner for a15
col db_link for a40
col username for a20
col host for a50
set pages 3000
select owner, db_link, username, host, created from dba_db_links
where owner like upper('%&1%')
and db_link like upper('%&2%');
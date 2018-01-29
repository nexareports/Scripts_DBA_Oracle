--set lines 250
--set pages 1000
--set feed off
col priv format a60

select	1 sort0,
	granted_role	priv,
	admin_option,
	default_role dflt
from	dba_role_privs
where	grantee = decode('&1','dbo','dbo',upper('&1'))
union
select	2 sort0,
	privilege	priv,
	admin_option,
	'' dflt
from	dba_sys_privs
where	grantee = decode('&1','dbo','dbo',upper('&1'))
union
select	3 sort0,
	privilege || ' on ' || owner || '.' || table_name || ' (by ' || grantor || ')'	priv,
	grantable admin_option,
	'' dflt
from	dba_tab_privs
where	grantee = decode('&1','dbo','dbo',upper('&1'))
union
select	4 sort0,
	'QUOTA: ' ||
	decode(q.max_bytes,
		-1, 'UNLIMITED',
		    ltrim(to_char(q.max_bytes/1048576,'999,999,990.00')) || 'M') ||
		' on ' || q.tablespace_name priv,
	'' admin_option,
	decode(u.default_tablespace, q.tablespace_name, 'YES', 'NO') dflt
from	dba_ts_quotas	q,
	dba_users	u
where	u.username = decode('&1','dbo','dbo',upper('&1'))
and	q.username = u.username
order by 1, 2, 3, 4
/
--set feed on


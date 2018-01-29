# Monta o script para disparar um trace, escolhendo o nível
select	'EXEC SYS.DBMS_SYSTEM.SET_EV (' || sid || ',' || serial# || ',10046,12,'||chr(39) || chr(39) ||');',
	'EXEC SYS.DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION (' || sid || ',' || serial# || ',false);'
	from	v$session
where	username in upper('PSBLEWF01')
and 	sid=;
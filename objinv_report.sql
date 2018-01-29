--set lines 250
--set pages 1000
--set serveroutput on SIZE 1000000;
--set feedback off;
Declare
	user_	varchar2(30);
	sql_	varchar2(150);
	cursor qtdobjinv is
			select owner,object_type,count(*) Qtd
			from dba_objects where status='INVALID'
			group by owner,object_type
			order by owner,object_type;
	cursor objinvsempkgbody is
		select owner,object_type,object_name
			from dba_objects where object_type not like '%BODY%' and status='INVALID';
	cursor objinvpkgbody is
		select owner,object_type,object_name
			from dba_objects where object_type like '%BODY%' and status='INVALID';
Begin
	dbms_output.put_line('==========================================================================');
	dbms_output.put_line(' QUANTIDADE DE OBJ INVÁLIDOS POR OWNER E POR TIPO DE OBJ');
	dbms_output.put_line('==========================================================================');
	for cont1 in qtdobjinv loop
		dbms_output.put_line('Owner='||cont1.owner||'  Tipo='||cont1.object_type||'  Qtd='||to_char(cont1.qtd));
	end loop;
	dbms_output.put_line('==========================================================================');
	dbms_output.put_line(' COMPILAÇÃO DE OBJS INVÁLIDOS');
	dbms_output.put_line('==========================================================================');
	for cont2 in objinvsempkgbody loop
		dbms_output.put_line('alter '||cont2.object_type||' '||cont2.owner||'.'||cont2.object_name||' compile;');
		dbms_output.put_line('show error');
	end loop;
	for cont2 in objinvpkgbody loop
		dbms_output.put_line('alter package '||cont2.owner||'.'||cont2.object_name||' compile body;');
		dbms_output.put_line('show error');
	end loop;
	dbms_output.put_line('==========================================================================');
	dbms_output.put_line(' FIM');
	dbms_output.put_line('==========================================================================');
End;
/
--set feedback on;
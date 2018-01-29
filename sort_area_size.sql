declare
v_addr raw(10);
v_text varchar2(230);
v_info varchar2(1000);
v_sort1 number;
v_sort2 number;
v_sort3 number;
v_sort4 number;
cursor c1 is
SELECT v$session.username, v$session.sid, serial#, contents, sql_address , extents
FROM v$session, v$sort_usage
WHERE v$session.saddr = v$sort_usage.session_addr ;
cursor c2 is
select * from v$sort_segment;
begin
dbms_output.put_line('*** currently sorting users ***');
for c1c in c1 loop
SELECT substr(SQL_TEXT,0,229) into v_text from v$sqlarea
where address=c1c.sql_address;
dbms_output.put_line(' USER:     '||c1c.username);
dbms_output.put_line(' EXTENTS:  '||c1c.extents );
dbms_output.put_line(' SQL_TEXT: '||v_text);
dbms_output.put_line('.');
end loop;
dbms_output.put_line('*** sort segments in the temporary tablespace***');
for c2c in c2 loop
dbms_output.put_line(' Extsz: '||c2c.EXTENT_SIZE||'  xacts: '||c2c.CURRENT_USERS||'  maxext: '||c2c.MAX_SIZE||'  curext: '||c2c.USED_EXTENTS||'  tbs: '||c2c.TABLESPACE_NAME );
end loop;
dbms_output.put_line('*** sort on disk/memory ***');
select value into v_sort1 from v$parameter where name='sort_area_size';
dbms_output.put_line(' SORT_AREA_SIZE: '||v_sort1);
select v$sysstat.value into v_sort2 from v$sysstat, v$statname
where v$sysstat.statistic#=v$statname.statistic#
and v$statname.name like 'sorts (memory)';
dbms_output.put_line(' SORT(MEMORY):   '||v_sort2);
select v$sysstat.value into v_sort3 from v$sysstat, v$statname
where v$sysstat.statistic#=v$statname.statistic#
and v$statname.name like 'sorts (disk)';
dbms_output.put_line(' SORT(DISKS):    '||v_sort3);
select v$sysstat.value into v_sort4 from v$sysstat, v$statname
where v$sysstat.statistic#=v$statname.statistic#
and v$statname.name like 'sorts (rows)';
dbms_output.put_line(' SORT(ROWS):     '||v_sort4);
dbms_output.put_line(' % on DISK:'||TO_CHAR((v_sort3/(v_sort3+v_sort2))*100,'90D99'));
end;
/

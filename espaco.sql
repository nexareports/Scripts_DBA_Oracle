SELECT sum(bytes)/1024/1024 "free space in Mb"
FROM dba_free_space;

SELECT sum(bytes)/1024/1024 "used space in Mb"
FROM dba_data_files;

SELECT owner, sum(bytes)/1024/1024 "used space in Mb"
FROM dba_segments
group by owner;

SELECT owner, created, sum(bytes)/1024/1024 "used space in Mb"
FROM dba_segments s, dba_users u
where s.owner=u.username
group by owner, created
order by created desc;
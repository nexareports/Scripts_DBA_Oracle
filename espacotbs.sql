set lines 250
set pages 1000
TTI "Ver consumo de espaço por tablespace e datafile"
SELECT Substr(df.tablespace_name,1,20) "Tablespace Name",
       Substr(df.file_name,1,40) "File Name",
       Round(df.bytes/1024/1024,2) "Size (M)",
       Round(e.used_bytes/1024/1024,2) "Used (M)",
       Round(f.free_bytes/1024/1024,2) "Free (M)",
       Rpad(' '|| Rpad ('X',Round(e.used_bytes*10/df.bytes,0), 'X'),11,'-') "% Used"
FROM   DBA_DATA_FILES DF,
       (SELECT file_id,
               Sum(Decode(bytes,NULL,0,bytes)) used_bytes
        FROM dba_extents
        GROUP by file_id) E,
       (SELECT Max(bytes) free_bytes,
               file_id
        FROM dba_free_space
        GROUP BY file_id) f
WHERE  e.file_id (+) = df.file_id
AND    df.file_id  = f.file_id (+)
ORDER BY df.tablespace_name,
         df.file_name;

TTI off


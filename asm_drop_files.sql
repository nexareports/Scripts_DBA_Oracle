
--set LINESIZE  255
--set PAGESIZE  9999
--set VERIFY    off
--set FEEDBACK  off
--set HEAD      off

COLUMN full_alias_path    FORMAT a255       HEAD 'File Name'
COLUMN disk_group_name    noprint

SELECT
    'ALTER DISKGROUP '  ||
        disk_group_name ||
        ' DROP FILE ''' || CONCAT('+' || disk_group_name, SYS_CONNECT_BY_PATH(alias_name, '/')) || ''';' full_alias_path
FROM
    ( SELECT
          g.name               disk_group_name
        , a.parent_index       pindex
        , a.name               alias_name
        , a.reference_index    rindex
        , f.type               type
      FROM
          v$asm_file f RIGHT OUTER JOIN v$asm_alias     a USING (group_number, file_number)
                                   JOIN v$asm_diskgroup g USING (group_number)
    )
WHERE type IS NOT NULL
START WITH (MOD(pindex, POWER(2, 24))) = 0
    CONNECT BY PRIOR rindex = pindex
/


SET SERVEROUTPUT ON
DECLARE
  l_blkcnt_cmp    PLS_INTEGER;
  l_blkcnt_uncmp  PLS_INTEGER;
  l_row_cmp       PLS_INTEGER;
  l_row_uncmp     PLS_INTEGER;
  l_cmp_ratio     NUMBER;
  l_comptype_str  VARCHAR2(32767);
BEGIN
  DBMS_COMPRESSION.get_compression_ratio (
    scratchtbsname  => 'STALM',
    ownname         => 'ALM',
    objname         => 'AUX_TCASHFLOW',
    subobjname      => NULL,
    comptype        => DBMS_COMPRESSION.comp_advanced,
    blkcnt_cmp      => l_blkcnt_cmp,
    blkcnt_uncmp    => l_blkcnt_uncmp,
    row_cmp         => l_row_cmp,
    row_uncmp       => l_row_uncmp,
    cmp_ratio       => l_cmp_ratio,
    comptype_str    => l_comptype_str,
    subset_numrows  => DBMS_COMPRESSION.comp_ratio_allrows,
    objtype         => DBMS_COMPRESSION.objtype_table
  );

  DBMS_OUTPUT.put_line('Number of blocks used (compressed)       : ' ||  l_blkcnt_cmp);
  DBMS_OUTPUT.put_line('Number of blocks used (uncompressed)     : ' ||  l_blkcnt_uncmp);
  DBMS_OUTPUT.put_line('Number of rows in a block (compressed)   : ' ||  l_row_cmp);
  DBMS_OUTPUT.put_line('Number of rows in a block (uncompressed) : ' ||  l_row_uncmp);
  DBMS_OUTPUT.put_line('Compression ratio                        : ' ||  l_cmp_ratio);
  DBMS_OUTPUT.put_line('Compression type                         : ' ||  l_comptype_str);
END;
/
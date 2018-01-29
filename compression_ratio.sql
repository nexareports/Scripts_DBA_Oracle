set serveroutput on

DECLARE
   v_blkcnt_cmp     PLS_INTEGER;
   v_blkcnt_uncmp   PLS_INTEGER;
   v_row_cmp        PLS_INTEGER;
   v_row_uncmp      PLS_INTEGER;
   v_cmp_ratio      NUMBER;
   v_comptype_str   VARCHAR2 (60);
BEGIN
   sys.dbms_compression.get_compression_ratio (
      scratchtbsname   => 'TS_ARCH',
      ownname          => 'ARCH',
      tabname          => 'VNUMBERS',
      partname         => NULL,
      comptype         => 2,
      blkcnt_cmp       => v_blkcnt_cmp,
      blkcnt_uncmp     => v_blkcnt_uncmp,
      row_cmp          => v_row_cmp,
      row_uncmp        => v_row_uncmp,
      cmp_ratio        => v_cmp_ratio,
      comptype_str     => v_comptype_str
   );
   DBMS_OUTPUT.put_line (
      'Estimated Compression Ratio: ' || TO_CHAR (v_cmp_ratio)
   );
   DBMS_OUTPUT.put_line (
      'Blocks used by compressed sample: ' || TO_CHAR (v_blkcnt_cmp)
   );
   DBMS_OUTPUT.put_line (
      'Blocks used by uncompressed sample: ' || TO_CHAR (v_blkcnt_uncmp)
   );
END;
/
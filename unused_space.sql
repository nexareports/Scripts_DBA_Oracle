--set SERVEROUTPUT ON
--set VERIFY OFF
DECLARE
  v_partition_name            VARCHAR2(30) := UPPER('&partition_name_');
  v_total_blocks              NUMBER;
  v_total_bytes               NUMBER;
  v_unused_blocks             NUMBER;
  v_unused_bytes              NUMBER;
  v_last_used_extent_file_id  NUMBER;
  v_last_used_extent_block_id NUMBER;
  v_last_used_block           NUMBER;
BEGIN
  IF v_partition_name != 'NA' THEN
    DBMS_SPACE.UNUSED_SPACE (segment_owner              => UPPER('&segment_owner_'), 
                             segment_name               => UPPER('&segment_name_'),
                             segment_type               => UPPER('&segment_type_'),
                             total_blocks               => v_total_blocks,
                             total_bytes                => v_total_bytes,
                             unused_blocks              => v_unused_blocks,
                             unused_bytes               => v_unused_bytes,
                             last_used_extent_file_id   => v_last_used_extent_file_id,
                             last_used_extent_block_id  => v_last_used_extent_block_id,
                             last_used_block            => v_last_used_block,
                             partition_name             => v_partition_name);
  ELSE
    DBMS_SPACE.UNUSED_SPACE (segment_owner              => UPPER('&segment_owner_'), 
                             segment_name               => UPPER('&segment_name_'),
                             segment_type               => UPPER('&segment_type_'),
                             total_blocks               => v_total_blocks,
                             total_bytes                => v_total_bytes,
                             unused_blocks              => v_unused_blocks,
                             unused_bytes               => v_unused_bytes,
                             last_used_extent_file_id   => v_last_used_extent_file_id,
                             last_used_extent_block_id  => v_last_used_extent_block_id,
                             last_used_block            => v_last_used_block);
  END IF;

  DBMS_OUTPUT.PUT_LINE('v_total_blocks              :' || v_total_blocks);
  DBMS_OUTPUT.PUT_LINE('v_total_bytes               :' || v_total_bytes);
  DBMS_OUTPUT.PUT_LINE('v_unused_blocks             :' || v_unused_blocks);
  DBMS_OUTPUT.PUT_LINE('v_unused_bytes              :' || v_unused_bytes);
  DBMS_OUTPUT.PUT_LINE('v_last_used_extent_file_id  :' || v_last_used_extent_file_id);
  DBMS_OUTPUT.PUT_LINE('v_last_used_extent_block_id :' || v_last_used_extent_block_id);
  DBMS_OUTPUT.PUT_LINE('v_last_used_block           :' || v_last_used_block);
END;
/

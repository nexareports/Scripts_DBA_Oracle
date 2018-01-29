--set SERVEROUTPUT ON SIZE 1000000
--set FEEDBACK OFF
--set TRIMOUT ON
--set VERIFY OFF

DECLARE
  CURSOR c_extents IS
    SELECT owner,
           segment_name,
           block_id AS start_block,
           block_id + blocks - 1 AS end_block
    FROM   dba_extents
    WHERE  tablespace_name = Upper('&1')
    ORDER BY block_id;
    
  l_last_block_id  NUMBER  := 0;
  l_gaps_only      BOOLEAN := FALSE;
BEGIN
  FOR cur_rec IN c_extents LOOP
    IF cur_rec.start_block > l_last_block_id + 1 THEN
      DBMS_OUTPUT.PUT_LINE('*** GAP *** (' || l_last_block_id || ' -> ' || cur_rec.start_block || ')');
    END IF;
    l_last_block_id := cur_rec.end_block;
    IF NOT l_gaps_only THEN
      DBMS_OUTPUT.PUT_LINE(RPAD(cur_rec.owner || '.' || cur_rec.segment_name, 40, ' ') || 
                           ' (' || cur_rec.start_block || ' -> ' || cur_rec.end_block || ')');
    END IF;
  END LOOP;
END;
/

PROMPT
--set FEEDBACK ON
--set PAGESIZE 18

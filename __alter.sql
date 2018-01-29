set echo on
alter session set db_file_multiblock_read_count=512;
alter session set optimizer_mode=RULE;
alter session set optimizer_index_caching=100;
alter session set optimizer_index_cost_adj=10000;
set echo off
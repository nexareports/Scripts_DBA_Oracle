spool ./output/feature_usaged.txt
set long 200000
SELECT output FROM TABLE(sys.dbms_feature_usage_report.display_text);
spool off
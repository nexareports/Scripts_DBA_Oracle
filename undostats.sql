SELECT to_char(begin_time,   'DD/MM/YYYY HH24:MI:SS') begin_time,
  to_char(end_time,   'DD/MM/YYYY HH24:MI:SS') end_time,
  undotsn,
  undoblks,
  txncount,
  maxconcurrency AS "MAXCON",
  MAXQUERYLEN,
  SSOLDERRCNT,
  TUNED_UNDORETENTION,
  EXPBLKREUCNT
FROM v$undostat
WHERE rownum <= 144
ORDER BY 1;

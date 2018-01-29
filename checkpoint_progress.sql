select
  le.leseq                        "Current log sequence No",
  100*cp.cpodr_bno/le.lesiz       "Percent Full",
  cp.cpodr_bno                    "Current Block No",
  le.lesiz                        "Size of Log in Blocks"
from
  x$kcccp cp,
  x$kccle le
where
  LE.leseq =CP.cpodr_seq
  and bitand(le.leflg,24)=8
/


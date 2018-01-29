
column redundant_index format a39
column sufficient_index format a39

select
  o1.name||'.'||n1.name  redundant_index,
  o2.name||'.'||n2.name  sufficient_index
from
  sys.icol$  ic1,
  sys.icol$  ic2,
  sys.ind$  i1,
  sys.obj$  n1,
  sys.obj$  n2,
  sys.user$  o1,
  sys.user$  o2
where
  ic1.pos# =1 and
  ic2.bo# =ic1.bo# and
  ic2.obj# !=ic1.obj# and
  ic2.pos# =1 and
  ic2.intcol# =ic1.intcol# and
  i1.obj# =ic1.obj# and
  bitand(i1.property, 1) =0 and
  ( select
      max(pos#) * (max(pos#) + 1) / 2
    from
      sys.icol$
    where
      obj# =ic1.obj#
  ) =
  ( select
      sum(xc1.pos#)
    from
      sys.icol$ xc1,
      sys.icol$ xc2
    where
      xc1.obj# =ic1.obj# and
      xc2.obj# =ic2.obj# and
      xc1.pos# =xc2.pos# and
      xc1.intcol# =xc2.intcol#
  ) and
  n1.obj# =ic1.obj# and
  n2.obj# =ic2.obj# and
  o1.user# =n1.owner# and
  o2.user# =n2.owner#
/



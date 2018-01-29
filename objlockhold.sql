col Username format A15
col Sid format 9990 heading SID
col Type format A4
col Lmode format 990 heading 'HELD'
col Request format 990 heading 'REQ'
col Id1 format 9999990
col Id2 format 9999990

select SN.Username, M.Sid, M.Type,
DECODE(M.Lmode, 0, 'None', 1, 'Null', 2, 'Row Share', 3, 'Row
Excl.', 4, 'Share', 5, 'S/Row Excl.', 6, 'Exclusive',
LTRIM(TO_CHAR(Lmode,'990'))) Lmode,
DECODE(M.Request, 0, 'None', 1, 'Null', 2, 'Row Share', 3, 'Row
Excl.', 4, 'Share', 5, 'S/Row Excl.', 6, 'Exclusive',
LTRIM(TO_CHAR(M.Request, '990'))) Request,
M.Id1, M.Id2 from V$SESSION SN, V$LOCK M
WHERE (SN.Sid = M.Sid and M.Request ! = 0)
or (SN.Sid = M.Sid and M.Request = 0 and Lmode != 4 and (id1, id2)
in (select S.Id1, S.Id2 from V$LOCK S where Request != 0 and S.Id1
= M.Id1 and S.Id2 = M.Id2) ) order by Id1, Id2, M.Request;
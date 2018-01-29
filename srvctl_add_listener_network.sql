--Existentes:
[oracle11@lpc0000aut03 binarios]$ srvctl config listener
Name: LISTENER
Network: 1, Owner: oracle11
Home: <CRS home>
End points: TCP:1521
[oracle11@lpc0000aut03 binarios]$ srvctl config network
Network exists: 1/10.123.105.0/255.255.255.128/eth0, type static

--no hosts
10.123.105.86   lpc0000aut03 lpc0000aut03-fe
10.123.106.74   lpc0000aut03-be
10.125.68.174   lpc0000aut03-gest
10.123.105.87   lpc0000aut04-fe lpc0000aut04
# Oracle: IPs de SCAN
#10.123.105.89  lpc0000sca04
#10.123.105.90  lpc0000sca04
#10.123.105.91  lpc0000sca04
#
# VIPs
#10.123.105.92  lpc0000aut03-vip01
#10.123.105.93  lpc0000aut04-vip01



eth0:1    Link encap:Ethernet  HWaddr 04:7D:7B:41:36:CC
          inet addr:10.123.105.92  Bcast:10.123.105.127  Mask:255.255.255.128
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          Memory:91c20000-91c40000

eth0:2    Link encap:Ethernet  HWaddr 04:7D:7B:41:36:CC
          inet addr:10.123.105.90  Bcast:10.123.105.127  Mask:255.255.255.128
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          Memory:91c20000-91c40000

eth1      Link encap:Ethernet  HWaddr 04:7D:7B:41:36:CD
          inet addr:10.123.106.74  Bcast:10.123.106.127  Mask:255.255.255.128
          inet6 addr: fe80::67d:7bff:fe41:36cd/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:23358274 errors:0 dropped:0 overruns:0 frame:0
          TX packets:6656 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2010016208 (1.8 GiB)  TX bytes:808645 (789.6 KiB)
          Memory:91c00000-91c20000

		  
		  
--A Fazer: ????????		  
srvctl add network -k 2 -S 10.123.106.0/255.255.255.128/eth1, type static

Feito mas pelo root:
/u01/app/11.2.0.3/grid/bin/srvctl add network -k 2 -S 10.123.106.0/255.255.255.128/eth1


--Adicionar listener:
srvctl add listener -l LISTENER_DR -o /u01/app/11.2.0.3/grid -p "TCP:1530" -k 2


[oracle11@lpc0000aut03 binarios]$ srvctl add listener -l LISTENER_DR -o /u01/app/11.2.0.3/grid -p "TCP:1530" -k 2
PRCR-1033 : Resource type ora.cluster_vip_net2.type does not exist
[oracle11@lpc0000aut03 binarios]$ srvctl add listener -l LISTENER_DR -o /u01/app/11.2.0.3/grid -p "TCP:1530" -k 2 -s
PRCR-1033 : Resource type ora.cluster_vip_net2.type does not exist
[oracle11@lpc0000aut03 binarios]$ srvctl add listener -l LISTENER_DR -o /u01/app/11.2.0.3/grid -p "TCP:1530"
[oracle11@lpc0000aut03 binarios]$ ps -ef | grep tns
root       165     2  0 Sep12 ?        00:00:00 [netns]
oracle11 20760     1  0 Oct19 ?        00:02:40 /u01/app/11.2.0.3/grid/bin/tnslsnr LISTENER_SCAN1 -inherit
oracle11 25461     1  0 09:49 ?        00:00:00 /u01/app/11.2.0.3/grid/bin/tnslsnr LISTENER -inherit
oracle11 25764     1  0 09:52 ?        00:00:00 /u01/app/11.2.0.3/grid/bin/tnslsnr LISTENER_DR -inherit
oracle11 27275 26042  0 10:20 pts/2    00:00:00 grep tns
[oracle11@lpc0000aut03 binarios]$ lsnrctl status LISTENER_DR

LSNRCTL for Linux: Version 11.2.0.3.0 - Production on 20-DEC-2012 10:20:48

Copyright (c) 1991, 2011, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=10.123.106.74)(PORT=1530)(IP=FIRST)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_DR
Version                   TNSLSNR for Linux: Version 11.2.0.3.0 - Production
Start Date                20-DEC-2012 09:52:38
Uptime                    0 days 0 hr. 28 min. 9 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /u01/app/11.2.0.3/grid/network/admin/listener.ora
Listener Log File         /u01/app/11.2.0.3/grid/log/diag/tnslsnr/lpc0000aut03/listener_dr/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=10.123.106.74)(PORT=1530)))
Services Summary...
Service "BDORAUT" has 1 instance(s).
  Instance "BDORAUT1", status READY, has 1 handler(s) for this service...
Service "BDORAUTXDB" has 1 instance(s).
  Instance "BDORAUT1", status READY, has 1 handler(s) for this service...
The command completed successfully






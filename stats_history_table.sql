col savtime for a31
col object_name for a12
col owner for a10
SELECT ob.owner, ob.object_name, ob.object_type,obj#, savtime, flags, rowcnt, blkcnt, avgrln ,samplesize, analyzetime
FROM sys.WRI$_OPTSTAT_TAB_HISTORY, dba_objects ob
WHERE owner=upper('&1')
and object_name=upper('&2')
and object_type in ('TABLE')
and object_id=obj#
;
col savtime clear
col object_name clear
col owner clear
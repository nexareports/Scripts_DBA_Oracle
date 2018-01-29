col	"Target Host" for a29
col	"OS Version" for a19
col	"OS Hardware" for a30
col	"DB Name" for a10
col	"DB Edition" for a18
col	"CPU Vendor" for a18
col	"CPU Type" for a50
col	"DB Count" 999
col	"Number of Cores" 999

select 
	distinct ohs.host_name "Target Host", 
	--ohs.distributor_version "OS Version", 
	ohs.system_config "OS Hardware", 
	DDI.database_name "DB Name", 
	--ddi.edition "DB Edition", 
	hcd.vendor_name "CPU Vendor", 
	hcd.IMPL "CPU Type", 
	hcd.instance_count "DB Count", 
	hcd.num_cores "Number of Cores"
from sysman.MGMT$HW_CPU_DETAILS HCD, sysman.mgmt$os_hw_summary OHS, SYSMAN.MGMT$DB_DBNINSTANCEINFO DDI
where HCD.target_guid=OHS.target_guid
and ohs.host_name=DDI.host_name
and ohs.host_name=DDI.host_name
group by ohs.host_name, ohs.distributor_version, ohs.system_config, DDI.database_name, DDI.edition,hcd.vendor_name, hcd.IMPL, hcd.instance_count, hcd.num_cores
order by 1,2;

col	"Target Host" clear
col	"OS Version" clear
col	"OS Hardware" clear
col	"DB Name" clear
col	"DB Edition" clear
col	"CPU Vendor" clear
col	"CPU Type" clear
col	"DB Count" clear
col	"Number of Cores" clear
#
# Cookbook Name:: service-off
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{acpid anacron apmd atd auditd autofs bluetooth cpuspeed cups firstboot gpm hidd ip6tables iptables kudzu lvm2-monitor mcstrans mdmonitor netfs nfslock pcscd portmap readahead_early restorecond rpcgssd rpcidmapd xfs yum-updatesd avahi-daemon lm_sensors sendmail avahi-daemon NetworkManager}.each do |service_name|
	service service_name do
		action [:disable, :stop]
	end
end

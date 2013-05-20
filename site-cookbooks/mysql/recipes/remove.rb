#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

service "mysqld" do
	action [:disable, :stop]
end

%w{mysql mysql-server}.each do |i|
 yum_package "#{i}" do
	action :remove
 end
end

bash "mysql" do
	user "root"
	code <<-EOH
	mysql_db=/var/lib/mysql
	mysql_conf=/etc/my.cnf.rpmsave

	if [ -d $mysql_db ]; then
		rm -rf $mysql_db
	 if [ -f $mysql_conf ]; then
		rm -rf $mysql_conf
	 fi
	fi

	EOH
end

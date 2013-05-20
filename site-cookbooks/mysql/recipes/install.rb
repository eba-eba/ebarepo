#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{mysql mysql-server}.each do |i|
 yum_package "#{i}" do
	action :install
 end
end

template "/etc/my.cnf" do
	source "my.cnf.erb"
end

service "mysqld" do
	action [:enable, :start]
end

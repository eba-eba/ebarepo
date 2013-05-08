#
# Cookbook Name:: httpd
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
yum_package "httpd" do
        action :install
end

template "/etc/httpd/conf/httpd.conf" do
	source "httpd.conf.erb"
end

service "httpd" do
        action [:enable, :start]
end

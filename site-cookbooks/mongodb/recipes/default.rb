#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
cookbook_file "/etc/yum.repos.d/10gen.repo" do
        source "10gen.repo"
        mode 0644
        owner "root"
        group "root"
end

yum_package "mongo-10gen" do
        action :install
end

yum_package "mongo-10gen-server" do
        action :install
end

template "/etc/mongod.conf" do
        source "mongod.conf.erb"
end

service "mongod" do
        action [:enable, :start]
end

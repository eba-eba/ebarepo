#
# Cookbook Name:: mongodb-remove
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
service "mongod" do
        action [:disable, :stop]
end

yum_package "mongo-10gen" do
        action :remove
end

yum_package "mongo-10gen-server" do
        action :remove
end

bash "mongodb-remove" do
        user "root"
        flags "-e" #実行中にエラーが発生した場合は、エラー発生時点で停止する

        code <<-EOH
        database=/var/lib/mongo

        if [ -d $database ]; then
                rm -rf $database
        fi
        EOH
end

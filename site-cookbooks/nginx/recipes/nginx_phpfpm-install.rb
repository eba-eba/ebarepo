#
# Cookbook Name:: nginx-phpfpm
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#php-fpm
#
bash "phpfpm-repo" do
	user "root"
	code <<-EOH
	rpm -qa |grep epel

	if [ "$?" = 1 ]; then
		rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi 
		rpm -ivh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
		rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm
	fi

	sed -i "s/enabled=0/enabled=1/g" /etc/yum.repos.d/epel.repo
	sed -i "s/enabled=0/enabled=1/g" /etc/yum.repos.d/remi.repo

	EOH
end

%w{php php-fpm php-devel php-cli php-xml php-mysql php-mbstring php-gd}.each do |i|
 yum_package "#{i}" do
	action :install	
 end
end

bash "phpfpm-repo02" do
	user "root"
	code <<-EOH

	sed -i "s/"enabled=1"/"enabled=0"/g" /etc/yum.repos.d/epel.repo
        sed -i "s/"enabled=1"/"enabled=0"/g" /etc/yum.repos.d/remi.repo

	EOH
end

template "/etc/php-fpm.d/www.conf" do
	source "phpfpm.conf.erb"
end

#nginx
#
filename = "nginx-1.2.2-2.ngx.i386.rpm"
file_checksum = "940abc0ff62e5adba490e4b1fa84b8e533317cdc4b14e315be1670e4e6145be0"

cookbook_file "/tmp/#{filename}" do
	source "#{filename}"
	checksum "#{file_checksum}"
end

package "nginx" do
	action :install
	provider Chef::Provider::Package::Rpm
	source "/tmp/#{filename}"
end

template "/etc/nginx/conf.d/nginx-http.conf" do
	source node['nginx']['nginx_confname']
end

template "#{node['nginx']['nginx_DocumentRoot']}/index.html" do
	source "index.html.erb"
	mode 00644
end

bash "nginx-orgconf" do
	user "root"
	code <<-HOE
	if [ -d /etc/nginx/conf.d/org ]; then
		echo ok
	 else
		mkdir /etc/nginx/conf.d/org
	fi

	if [ -f /etc/nginx/conf.d/default.conf ]; then
		mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/org

		if [ -f /etc/nginx/conf.d/example_ssl.conf ]; then
			mv /etc/nginx/conf.d/example_ssl.conf /etc/nginx/conf.d/org
		fi
	fi
	HOE
end

service "nginx" do
	action [:enable, :start]
end

#
# Cookbook Name:: setup-mongo
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "mongodb-cleanup" do
        user "root"
	flags "-e"
        code <<-EOH
        mongo admin --eval "db.shutdownServer()"
        sed -i "s/^replSet/#replSet/g" /etc/mongod.conf
        if [ -e /var/lib/mongo/mongod.lock ]; then
                rm -r /var/lib/mongo/mongod.lock
        fi

        /etc/init.d/mongod start
        mongo adfurikun-prd --eval "db.dropDatabase()"
        mongo admin --eval "db.shutdownServer()"
        sed -i "s/^#replSet/replSet/g" /etc/mongod.conf

        if [ -e /var/lib/mongo/mongod.lock ]; then
                rm -r /var/lib/mongo/mongod.lock
        fi

        /etc/init.d/mongod start
        EOH
end

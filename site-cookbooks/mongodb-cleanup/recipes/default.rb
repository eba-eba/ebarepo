#
# Cookbook Name:: setup-mongo
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "setup-mongo" do
        user "root"
	flags "-e"
        code <<-EOH
        #MongoDB 停止
        mongo admin --eval "db.shutdownServer()"

        #mongod.conf 修正
        sed -i "s/^replSet/#replSet/g" /etc/mongod.conf

        #lockファイルの削除
        if [ -e /var/lib/mongo/mongod.lock ]; then
                rm -r /var/lib/mongo/mongod.lock
        fi

        #MongoDB 起動
        /etc/init.d/mongod start

        #Database 削除
        mongo adfurikun-prd --eval "db.dropDatabase()"

        #MongoDB 停止
        mongo admin --eval "db.shutdownServer()"

        #mongod.conf 修正
        sed -i "s/^#replSet/replSet/g" /etc/mongod.conf

        #lockファイル削除
        if [ -e /var/lib/mongo/mongod.lock ]; then
                rm -r /var/lib/mongo/mongod.lock
        fi

        #MongoDB 起動
        /etc/init.d/mongod start
        EOH
end

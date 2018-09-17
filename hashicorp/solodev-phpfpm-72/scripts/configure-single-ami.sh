echo "Init Solodev client drive"
mkfs.ext4 /dev/xvdb
echo '/dev/xvdb /var/www/Solodev/clients/solodev ext4 defaults,auto,noexec 0 0' >> /etc/fstab
blockdev --setra 32 /dev/xvdb

echo "Download server vars from AWS"
tee /root/init-solodev.sh <<EOF
#!/bin/bash
EC2_INSTANCE_ID="`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id || die \"wget instance-id has failed: $?\"`"
test -n "\$EC2_INSTANCE_ID" || die 'cannot obtain instance-id'
EC2_AVAIL_ZONE="`wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone || die \"wget availability-zone has failed: $?\"`"
test -n "\$EC2_AVAIL_ZONE" || die 'cannot obtain availability-zone'
EC2_REGION="\`echo "\$EC2_AVAIL_ZONE" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'\`"

echo "Create Solodev database and user"
echo "CREATE DATABASE solodev;" >> /tmp/setup.mysql
echo "GRANT ALL ON solodev.* TO solodevsql@127.0.0.1 IDENTIFIED BY '\$EC2_INSTANCE_ID';" >> /tmp/setup.mysql

echo "Set mysql user permissions"
mysqladmin -u root password \$EC2_INSTANCE_ID
mysql -u root --password=\$EC2_INSTANCE_ID < /tmp/setup.mysql

echo "Create mysql backup script"
echo '#!/bin/bash' > /root/dumpmysql.sh
echo "mkdir -p /var/www/Solodev/clients/solodev/dbdumps" >> /root/dumpmysql.sh
echo "PWD=/var/www/Solodev/clients/solodev/dbdumps" >> /root/dumpmysql.sh
echo 'DBFILE=\$PWD/databases.txt' >> /root/dumpmysql.sh
echo 'rm -f \$DBFILE' >> /root/dumpmysql.sh
echo '/usr/bin/mysql -u root -p\$EC2_INSTANCE_ID mysql -Ns -e "show databases" > \$DBFILE' >> /root/dumpmysql.sh
echo 'for i in \`cat \$DBFILE\` ; do mysqldump --opt --single-transaction -u root -p\$EC2_INSTANCE_ID \$i > \$PWD/\$i.sql ; done' >> /root/dumpmysql.sh
echo "# Compress Backups" >> /root/dumpmysql.sh
echo 'for i in \`cat \$DBFILE\` ; do gzip -f \$PWD/\$i.sql ; done' >> /root/dumpmysql.sh
chmod 700 /root/dumpmysql.sh

echo "Add Mysql dump to Crontab"
(crontab -l 2>/dev/null; echo "30 13 * * * /root/dumpmysql.sh") | crontab -

echo "Configure Mongo"
echo 'use solodev_views;' > /root/mongouser.js
echo 'db.createUser({"user": "solodevsql", "pwd": "\$EC2_INSTANCE_ID", "roles": [ { role: "readWrite", db: "solodev_views" } ] })' >> /root/mongouser.js
mongo < /root/mongouser.js
rm -Rf /root/mongouser.js

echo "Create default Solodev folders"	
mkdir -p /var/www/Solodev/clients/solodev/Vhosts		
mkdir -p /var/www/Solodev/clients/solodev/s.Vhosts				
mkdir -p /var/www/Solodev/clients/solodev/Main
mv /var/www/Solodev/core/aws/Client_Settings.xml /var/www/Solodev/clients/solodev/Client_Settings.xml

echo "Configure Solodev config"			
sed -i "s/REPLACE_WITH_DATABASE/solodev/g" /var/www/Solodev/clients/solodev/Client_Settings.xml
sed -i "s/REPLACE_WITH_MONGOHOST/127.0.0.1/g" /var/www/Solodev/clients/solodev/Client_Settings.xml
sed -i "s/REPLACE_WITH_DBHOST/127.0.0.1/g" /var/www/Solodev/clients/solodev/Client_Settings.xml
sed -i "s/REPLACE_WITH_DBUSER/solodevsql/g" /var/www/Solodev/clients/solodev/Client_Settings.xml
sed -i "s/REPLACE_WITH_DBPASSWORD/\$EC2_INSTANCE_ID/g" /var/www/Solodev/clients/solodev/Client_Settings.xml

echo "Install Solodev"
php /var/www/Solodev/core/update.php admin \$EC2_INSTANCE_ID >> /root/phpinstall.log
chmod -Rf 2770 /var/www/Solodev/clients
chown -Rf apache.apache /var/www/Solodev/clients
#rm -f /root/init-solodev.sh
EOF

chmod 700 /root/init-solodev.sh

#Install Cloud Init script
# tee /etc/cloud/cloud.cfg.d/install.cfg <<EOF
# #install-config
# runcmd:
#  - /root/init-solodev.sh
# EOF
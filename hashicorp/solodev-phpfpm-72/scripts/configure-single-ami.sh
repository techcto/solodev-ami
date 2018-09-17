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
MOUNT = "/var/www/Solodev/clients/solodev"

echo "Create Solodev database and user"
echo "CREATE DATABASE solodev;" >> /tmp/setup.mysql
echo "GRANT ALL ON solodev.* TO solodevsql@127.0.0.1 IDENTIFIED BY '\$EC2_INSTANCE_ID';" >> /tmp/setup.mysql

echo "Set mysql user permissions"
mysqladmin -u root password \$EC2_INSTANCE_ID
mysql -u root --password=\$EC2_INSTANCE_ID < /tmp/setup.mysql

echo "Configure Mongo"
echo 'use solodev_views;' > /root/mongouser.js
echo 'db.createUser({"user": "solodevsql", "pwd": "'"$EC2_INSTANCE_ID"'", "roles": [ { role: "readWrite", db: "solodev_views" } ] })' >> /root/mongouser.js
mongo < /root/mongouser.js
rm -Rf /root/mongouser.js

echo "Create default Solodev folders"	
mkdir -p $MOUNT/Vhosts		
mkdir -p $MOUNT/s.Vhosts				
mkdir -p $MOUNT/Main
mv /var/www/Solodev/core/aws/Client_Settings.xml $MOUNT/Client_Settings.xml

echo "Configure Solodev config"			
sed -i "s/REPLACE_WITH_DATABASE/solodev/g" $MOUNT/Client_Settings.xml
sed -i "s/REPLACE_WITH_MONGOHOST/127.0.0.1/g" $MOUNT/Client_Settings.xml
sed -i "s/REPLACE_WITH_DBHOST/127.0.0.1/g" $MOUNT/Client_Settings.xml
sed -i "s/REPLACE_WITH_DBUSER/solodevsql/g" $MOUNT/Client_Settings.xml
sed -i "s/REPLACE_WITH_DBPASSWORD/\$EC2_INSTANCE_ID/g" $MOUNT/Client_Settings.xml

echo "Install Solodev"
php /var/www/Solodev/core/update.php admin \$EC2_INSTANCE_ID >> /root/phpinstall.log
chmod -Rf 2770 /var/www/Solodev/clients
chown -Rf apache.apache /var/www/Solodev/clients

echo "Init default data dirs"
mkdir -p $MOUNT/dbdumps	
mkdir -p $MOUNT/mongodumps

echo "Create mysql backup script"
echo '#!/bin/bash' > /root/dumpmysql.sh
echo "mkdir -p /var/www/Solodev/clients/solodev/dbdumps" >> /root/dumpmysql.sh
echo "PWD=/var/www/Solodev/clients/solodev/dbdumps" >> /root/dumpmysql.sh
echo 'DBFILE=\$PWD/databases.txt' >> /root/dumpmysql.sh
echo 'rm -f \$DBFILE' >> /root/dumpmysql.sh
echo '/usr/bin/mysql -u root -p'"$EC2_INSTANCE_ID"' mysql -Ns -e "show databases" > \$DBFILE' >> /root/dumpmysql.sh
echo 'for i in \`cat \$DBFILE\` ; do mysqldump --opt --single-transaction -u root -p'"$EC2_INSTANCE_ID"' \$i > \$PWD/\$i.sql ; done' >> /root/dumpmysql.sh
echo "# Compress Backups" >> /root/dumpmysql.sh
echo 'for i in \`cat \$DBFILE\` ; do gzip -f \$PWD/\$i.sql ; done' >> /root/dumpmysql.sh
chmod 700 /root/dumpmysql.sh

echo "Install restore scripts"
yum install -y duplicity duply python-boto mysql --enablerepo=epel
curl -qL -o jq https://stedolan.github.io/jq/download/linux64/jq && chmod +x ./jq

echo "Init Duply backup config"
duply backup create
perl -pi -e 's/GPG_KEY/#GPG_KEY/g' /etc/duply/backup/conf
perl -pi -e 's/GPG_PW/#GPG_PW/g' /etc/duply/backup/conf
echo "GPG_PW=\$EC2_INSTANCE_ID" >> /etc/duply/backup/conf
echo "TARGET='s3+http://BACKUP-BUCKET/backups'" >> /etc/duply/backup/conf
echo "TARGET_USER='IAM_ACCESS_KEY'" >> /etc/duply/backup/conf
echo "TARGET_PASS='IAM_SECRET_KEY'" >> /etc/duply/backup/conf
echo "SOURCE=\$MOUNT" >> /etc/duply/backup/conf
echo "MAX_AGE='1W'" >> /etc/duply/backup/conf
echo "MAX_FULL_BACKUPS='2'" >> /etc/duply/backup/conf
echo "MAX_FULLBKP_AGE=1W" >> /etc/duply/backup/conf
echo "VOLSIZE=100" >> /etc/duply/backup/conf
echo 'DUPL_PARAMS="$DUPL_PARAMS --volsize $VOLSIZE"' >> /etc/duply/backup/conf
echo 'DUPL_PARAMS="$DUPL_PARAMS --full-if-older-than $MAX_FULLBKP_AGE"' >> /etc/duply/backup/conf

echo "/root/dumpmysql.sh >/dev/null 2>&1" > /etc/duply/backup/pre
echo "mongodump --out \$MOUNT/mongodumps >/dev/null 2>&1" >> /etc/duply/backup/pre

echo "/root/dumpmysql.sh" > /root/backup.sh
echo "duply backup backup" >> /root/backup.sh
chmod 700 /root/backup.sh

echo "Add backup routine to Crontab"
(crontab -l 2>/dev/null; echo "30 13 * * * /root/backup.sh") | crontab -
         
echo "Generate restore script"
echo "#!/bin/bash" >> /root/restore.sh
echo "mv \$MOUNT/Client_Settings.xml \$MOUNT/Client_Settings.xml.bak" >> /root/restore.sh
echo "sudo alternatives --install /usr/bin/python  python /usr/bin/python2.6 1" >> /root/restore.sh
echo "sudo alternatives --set python /usr/bin/python2.6" >> /root/restore.sh
echo "export PASSPHRASE=\$EC2_INSTANCE_ID" >> /root/restore.sh
echo "duplicity --force -v8 restore s3+http://RESTORE-BUCKET/backups/ \$MOUNT" >> /root/restore.sh
echo "chmod -Rf 2770 \$MOUNT" >> /root/restore.sh
echo "chown -Rf apache.apache \$MOUNT" >> /root/restore.sh
echo "gunzip < \$MOUNT/dbdumps/solodev.sql.gz | mysql -u root -p\$EC2_INSTANCE_ID solodev" >> /root/restore.sh
echo "mongorestore \$MOUNT/mongodumps" >> /root/restore.sh
echo "rm -f \$MOUNT/Client_Settings.xml" >> /root/restore.sh
echo "mv \$MOUNT/Client_Settings.xml.bak \$MOUNT/Client_Settings.xml" >> /root/restore.sh
echo "sudo alternatives --remove python /usr/bin/python2.6" >> /root/restore.sh
chmod 700 /root/restore.sh

#rm -f /root/init-solodev.sh
EOF
chmod 700 /root/init-solodev.sh

#Install Cloud Init script
# tee /etc/cloud/cloud.cfg.d/install.cfg <<EOF
# #install-config
# runcmd:
#  - /root/init-solodev.sh
# EOF
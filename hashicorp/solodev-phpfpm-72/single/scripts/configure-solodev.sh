#Install Solodev from /tmp
mv /tmp/Solodev /var/www/Solodev
ls -al /var/www/Solodev
mkdir -p /var/www/Solodev/tmp
chown -Rf apache.apache /var/www/Solodev
chmod -Rf 2770 /var/www/Solodev

#Configure solodev.conf
echo "<Directory \"/var/www/Solodev\">" >> /etc/httpd/conf.d/solodev.conf
echo "Options -Indexes" >> /etc/httpd/conf.d/solodev.conf
echo "Options FollowSymLinks" >> /etc/httpd/conf.d/solodev.conf
echo "#AllowOverride None" >> /etc/httpd/conf.d/solodev.conf
echo "AllowOverride All" >> /etc/httpd/conf.d/solodev.conf
echo "Order allow,deny" >> /etc/httpd/conf.d/solodev.conf
echo "Allow from all" >> /etc/httpd/conf.d/solodev.conf
echo "</Directory>" >> /etc/httpd/conf.d/solodev.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /core /var/www/Solodev/core/html_core" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /CK /var/www/Solodev/public/www/node_modules/ckeditor-full" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /api /var/www/Solodev/core/api" >> /etc/httpd/conf.d/solodev.conf
echo "ErrorDocument 404 /" >> /etc/httpd/conf.d/solodev.conf
echo "ErrorDocument 401 /" >> /etc/httpd/conf.d/solodev.conf
echo "ServerName localhost" >> /etc/httpd/conf.d/solodev.conf
echo "DocumentRoot /var/www/Solodev/public/www" >> /etc/httpd/conf.d/solodev.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/solodev.conf
echo "IncludeOptional /var/www/Solodev/clients/solodev/Vhosts/*.*" >> /etc/httpd/conf.d/solodev.conf
echo "IncludeOptional /var/www/Solodev/clients/solodev/s.Vhosts/*.*" >> /etc/httpd/conf.d/solodev.conf

#Add Solodev to Crontab
mv /tmp/restart.php /root/restart.php
(crontab -l 2>/dev/null; echo "*/2 * * * * php /root/restart.php") | crontab -
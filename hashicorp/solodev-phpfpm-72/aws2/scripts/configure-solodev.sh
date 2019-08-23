#Install Solodev from /tmp
mv /tmp/Solodev /var/www/solodev
ls -al /var/www/solodev
chown -Rf apache.apache /var/www/solodev
chmod -Rf 2770 /var/www/solodev

#Configure solodev.conf
echo "<Directory \"/var/www/solodev\">" >> /etc/httpd/conf.d/solodev.conf
echo "Options -Indexes" >> /etc/httpd/conf.d/solodev.conf
echo "Options -MultiViews" >> /etc/httpd/conf.d/solodev.conf
echo "Options FollowSymLinks" >> /etc/httpd/conf.d/solodev.conf
echo "AllowOverride All" >> /etc/httpd/conf.d/solodev.conf
echo "Require all granted" >> /etc/httpd/conf.d/solodev.conf
echo "</Directory>" >> /etc/httpd/conf.d/solodev.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /core /var/www/solodev/core/html_core" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /CK/config.js /var/www/solodev/public/www/__/js/ck/config.js" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /CK /var/www/solodev/public/www/node_modules/ckeditor" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /api /var/www/solodev/core/api" >> /etc/httpd/conf.d/solodev.conf
echo "ErrorDocument 404 /" >> /etc/httpd/conf.d/solodev.conf
echo "ErrorDocument 401 /" >> /etc/httpd/conf.d/solodev.conf
echo "ServerName localhost" >> /etc/httpd/conf.d/solodev.conf
echo "DocumentRoot /var/www/solodev/public/www" >> /etc/httpd/conf.d/solodev.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/solodev.conf
echo "IncludeOptional /var/www/solodev/clients/solodev/Vhosts/*.*" >> /etc/httpd/conf.d/solodev.conf
echo "IncludeOptional /var/www/solodev/clients/solodev/s.Vhosts/*.*" >> /etc/httpd/conf.d/solodev.conf

#Add Solodev to Crontab
(crontab -l 2>/dev/null; echo "*/2 * * * * php /var/www/solodev/core/utils/restart.php") | crontab -

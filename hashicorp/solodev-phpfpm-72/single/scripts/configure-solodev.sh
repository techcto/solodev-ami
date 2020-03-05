#Install Solodev from /tmp
mv /tmp/Solodev /var/www/solodev
ls -al /var/www/solodev
mkdir -p /var/www/solodev/tmp
chown -Rf apache.apache /var/www/solodev
chmod -Rf 2770 /var/www/solodev
mkdir -p /var/www/solodev/clients/solodev

#Configure solodev.conf
echo "<Directory \"/var/www/solodev\">" >> /etc/httpd/conf.d/solodev.conf
echo "Options -Indexes" >> /etc/httpd/conf.d/solodev.conf
echo "Options -MultiViews" >> /etc/httpd/conf.d/solodev.conf
echo "Options FollowSymLinks" >> /etc/httpd/conf.d/solodev.conf
echo "AllowOverride All" >> /etc/httpd/conf.d/solodev.conf
echo "Require all granted" >> /etc/httpd/conf.d/solodev.conf
echo "</Directory>" >> /etc/httpd/conf.d/solodev.conf
echo "<Directory \"/var/www/solodev/public\">" >> /etc/httpd/conf.d/solodev.conf
echo "DirectoryIndex app.php" >> /etc/httpd/conf.d/solodev.conf
echo "</Directory>" >> /etc/httpd/conf.d/solodev.conf
echo "<Directory \"/var/www/solodev/public/www/CMS\">" >> /etc/httpd/conf.d/solodev.conf
echo "DirectoryIndex index.stml" >> /etc/httpd/conf.d/solodev.conf
echo "</Directory>" >> /etc/httpd/conf.d/solodev.conf
echo "<Directory \"/var/www/solodev/clients\">" >> /etc/httpd/conf.d/solodev.conf                                                                                                                                                                                                                                                            
echo "DirectoryIndex index.stml" >> /etc/httpd/conf.d/solodev.conf
echo "</Directory>" >> /etc/httpd/conf.d/solodev.conf
echo "<Directory \"/var/www/solodev/clients\">" >> /etc/httpd/conf.d/solodev.conf                                                                                                                                                                                                                                            
echo "DirectoryIndex index.stml" >> /etc/httpd/conf.d/solodev.conf
echo "# CORE LEGACY REDIRECTS" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/adminValidatePrereq.js https://cdn.solodev.com/portal/adminValidatePrereq.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/pager-1.0.js https://cdn.solodev.com/portal/pager-1.0.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/pager-api.js https://cdn.solodev.com/portal/pager-api.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/underscore-min.js https://cdn.solodev.com/portal/underscore-min.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/date-format.js https://cdn.solodev.com/portal/date-format.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/images/solodev/icons/jpg.png https://cdn.solodev.com/portal/images/solodev/icons/jpg.png" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/images/solodev/icons/pdf.png https://cdn.solodev.com/portal/images/solodev/icons/pdf.png" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/images/solodev/icons/png.png https://cdn.solodev.com/portal/images/solodev/icons/png.png" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/portal/getEventDetails.js https://cdn.solodev.com/portal/getEventDetails.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/builder/js/jquery.validationEngine.js https://cdn.solodev.com/builder/js/jquery.validationEngine.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/builder/js/jquery.validationEngine-en.js https://cdn.solodev.com/builder/js/jquery.validationEngine-en.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/builder/css/validationEngine.jquery.css https://cdn.solodev.com/builder/css/validationEngine.jquery.css" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /core/analytics/ct.js https://cdn.solodev.com/analytics/ct.js" >> /etc/httpd/conf.d/solodev.conf
echo "# ASSETS REDIRECTS" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/adminValidatePrereq.js https://cdn.solodev.com/portal/adminValidatePrereq.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/pager-1.0.js https://cdn.solodev.com/portal/pager-1.0.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/pager-api.js https://cdn.solodev.com/portal/pager-api.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/underscore-min.js https://cdn.solodev.com/portal/underscore-min.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/date-format.js https://cdn.solodev.com/portal/date-format.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/images/solodev/icons/jpg.png https://cdn.solodev.com/portal/images/solodev/icons/jpg.png" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/images/solodev/icons/pdf.png https://cdn.solodev.com/portal/images/solodev/icons/pdf.png" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/images/solodev/icons/png.png https://cdn.solodev.com/portal/images/solodev/icons/png.png" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/portal/getEventDetails.js https://cdn.solodev.com/portal/getEventDetails.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/builder/js/jquery.validationEngine.js https://cdn.solodev.com/builder/js/jquery.validationEngine.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/builder/js/jquery.validationEngine-en.js https://cdn.solodev.com/builder/js/jquery.validationEngine-en.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/builder/css/validationEngine.jquery.css https://cdn.solodev.com/builder/css/validationEngine.jquery.css" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/analytics/ct.js https://cdn.solodev.com/analytics/ct.js" >> /etc/httpd/conf.d/solodev.conf
echo "Redirect 301 /assets/google/search-script.js https://cdn.solodev.com/google/search-script.js" >> /etc/httpd/conf.d/solodev.conf
echo "</Directory>" >> /etc/httpd/conf.d/solodev.conf
echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /core /var/www/solodev/core/html_core" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /CK/config.js /var/www/solodev/public/www/__/js/ck/config.js" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /CK /var/www/solodev/public/www/node_modules/ckeditor4" >> /etc/httpd/conf.d/solodev.conf
echo "Alias /api /var/www/solodev/core/api" >> /etc/httpd/conf.d/solodev.conf
echo "ErrorDocument 404 /" >> /etc/httpd/conf.d/solodev.conf
echo "ErrorDocument 401 /" >> /etc/httpd/conf.d/solodev.conf
echo "ServerName localhost" >> /etc/httpd/conf.d/solodev.conf
echo "DocumentRoot /var/www/solodev/public/www" >> /etc/httpd/conf.d/solodev.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/solodev.conf
echo "IncludeOptional /var/www/solodev/clients/solodev/Vhosts/*.*" >> /etc/httpd/conf.d/solodev.conf
echo "IncludeOptional /var/www/solodev/clients/solodev/s.Vhosts/*.*" >> /etc/httpd/conf.d/solodev.conf

#Add Solodev to Crontab
mv /tmp/restart.php /root/restart.php
mv /tmp/check.sh /root/check.sh
mv /tmp/client.env /root/client.env
(crontab -l 2>/dev/null; echo "*/2 * * * * php /root/restart.php") | crontab -
(crontab -l 2>/dev/null; echo "0,15,30,45 * * * * php /root/check.sh") | crontab -
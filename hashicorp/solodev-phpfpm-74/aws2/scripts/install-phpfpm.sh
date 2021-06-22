yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --disable 'remi-php*'
yum-config-manager --enable remi-php74

#Install Tidy
# TIDY_VERSION=5.1.25
# mkdir -p /usr/local/src
# cd /usr/local/src
# curl -q https://codeload.github.com/htacg/tidy-html5/tar.gz/$TIDY_VERSION | tar -xz
# cd tidy-html5-$TIDY_VERSION/build/cmake
# cmake ../.. && make install
# ln -s tidybuffio.h ../../../../include/buffio.h
# cd /usr/local/src
# rm -rf /usr/local/src/tidy-html5-$TIDY_VERSION
yum -y install tidy

#Install PHP-FPM 7.4
yum install -y php74-php-fpm php74-php-common \
php74-php-devel php74-php-mysqli php74-php-mysqlnd php74-php-pdo_mysql \
php74-php-gd php74-php-mbstring php74-php-pear php74-php-soap php74-php-tidy \
php74-php-pecl-mongodb php74-php-pecl-apcu php74-php-pecl-oauth php74-php-zip 
scl enable php74 'php -v'
ln -s /usr/bin/php74 /usr/bin/php

#Tmp hack
# yum install -y php74-php-zip 
# rpm -e --nodeps libzip5
# yum install -y libzip

#Configure PHP-FPM conf for Apache (php74-php.conf)
rm -Rf /etc/httpd/conf.d/php.conf

echo '<Files ".user.ini">' >> /etc/httpd/conf.d/php74-php.conf
echo 'Require all denied' >> /etc/httpd/conf.d/php74-php.conf
echo '</Files>' >> /etc/httpd/conf.d/php74-php.conf
echo "AddHandler .stml .php" >> /etc/httpd/conf.d/php74-php.conf
echo "AddType text/html .stml .php" >> /etc/httpd/conf.d/php74-php.conf
echo "DirectoryIndex index.stml index.php" >> /etc/httpd/conf.d/php74-php.conf
echo 'SetEnvIfNoCase ^Authorization$ "(.+)" HTTP_AUTHORIZATION=$1' >> /etc/httpd/conf.d/php74-php.conf
echo "<FilesMatch \.(php|phar|stml)$>" >> /etc/httpd/conf.d/php74-php.conf
echo ' SetHandler "proxy:fcgi://127.0.0.1:9000"' >> /etc/httpd/conf.d/php74-php.conf
echo "</FilesMatch>" >> /etc/httpd/conf.d/php74-php.conf
echo "request_terminate_timeout = 0" >> /etc/opt/remi/php74/php-fpm.d/www.conf
echo "security.limit_extensions = .php .stml .xml" >> /etc/opt/remi/php74/php-fpm.d/www.conf
echo "listen.owner = apache" >> /etc/opt/remi/php74/php-fpm.d/www.conf
echo "listen.mode = 0660" >> /etc/opt/remi/php74/php-fpm.d/www.conf
echo "chdir = /var/www" >> /etc/opt/remi/php74/php-fpm.d/www.conf
echo "pm.max_requests = 500" >> /etc/opt/remi/php74/php-fpm.d/www.conf
echo "pm.max_children = 200" >> /etc/opt/remi/php74/php-fpm.d/www.conf

#Update Hosts file to resolve local solodev
echo "#Solodev PHP-FPM" >> /etc/hosts
echo "127.0.0.1 solodev" >> /etc/hosts

#Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer

#Install Redis Extension
yum install -y php74-php-pecl-redis

#Install IonCube
wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xzf ioncube_loaders_lin_x86-64.tar.gz
cd ioncube/
cp ioncube_loader_lin_7.2.so /opt/remi/php74/root/usr/lib64/php/modules/

#Configure php.ini
echo "short_open_tag = On" >> /etc/opt/remi/php74/php.ini
echo "expose_php = Off" >>/etc/opt/remi/php74/php.ini
echo "max_execution_time = 90" >>/etc/opt/remi/php74/php.ini
echo "max_input_time = 90" >>/etc/opt/remi/php74/php.ini
echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE & ~E_STRICT & ~E_WARNING" >>/etc/opt/remi/php74/php.ini
echo "post_max_size = 60M" >>/etc/opt/remi/php74/php.ini
echo "upload_max_filesize = 60M" >>/etc/opt/remi/php74/php.ini
echo "date.timezone = UTC" >>/etc/opt/remi/php74/php.ini
echo "realpath_cache_size = 1M" >>/etc/opt/remi/php74/php.ini
echo "session.save_handler = files" >>/etc/opt/remi/php74/php.ini
echo "session.save_path = \"/var/opt/remi/php74/lib/php/session\"" >>/etc/opt/remi/php74/php.ini
echo "session.gc_maxlifetime = 1200" >>/etc/opt/remi/php74/php.ini
echo "session.cookie_secure = 1" >>/etc/opt/remi/php74/php.ini
echo "[apcu]" >>/etc/opt/remi/php74/php.ini
echo "apc.enabled=1" >>/etc/opt/remi/php74/php.ini
echo "apc.shm_size=32M" >>/etc/opt/remi/php74/php.ini
echo "apc.ttl=7200" >>/etc/opt/remi/php74/php.ini
echo "apc.enable_cli=0" >>/etc/opt/remi/php74/php.ini
echo "apc.serializer=php" >>/etc/opt/remi/php74/php.ini
echo "apc.stat=0" >>/etc/opt/remi/php74/php.ini
echo "[custom]" >>/etc/opt/remi/php74/php.ini
echo "realpath_cache_ttl = 7200" >>/etc/opt/remi/php74/php.ini
echo "realpath_cache_size = 4096k" >>/etc/opt/remi/php74/php.ini
echo "opcache.enable=1" >>/etc/opt/remi/php74/php.ini
echo "opcache.memory_consumption=128" >>/etc/opt/remi/php74/php.ini
echo "opcache.max_accelerated_files=4000" >>/etc/opt/remi/php74/php.ini
echo "opcache_revalidate_freq = 240" >>/etc/opt/remi/php74/php.ini
echo "zend_extension=/opt/remi/php74/root/usr/lib64/php/modules/ioncube_loader_lin_7.2.so" >>/etc/opt/remi/php74/php.ini

#Start
chkconfig php74-php-fpm on
#Install Package Repos (REMI, EPEL)
yum -y remove php* httpd*

#Install Required Devtools
yum -y install gcc-c++ gcc pcre-devel make zip unzip wget curl cmake git yum-utils
wget http://195.220.108.108/linux/epel/6/x86_64/Packages/s/scl-utils-20120229-1.el6.x86_64.rpm
rpm -Uvh scl-utils-20120229-1.el6.x86_64.rpm

#Install Required Repos
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
wget http://rpms.remirepo.net/enterprise/remi-release-6.rpm
rpm -Uvh epel-release-latest-6.noarch.rpm
rpm -Uvh remi-release-6.rpm
yum-config-manager --enable remi-php72
yum --enablerepo=epel --disablerepo=amzn-main -y install libwebp

#Update all libs
yum update -y

#Clear cache dir
rm -Rf /var/cache/yum/base/packages

#Make swap for performance
/bin/dd if=/dev/zero of=/mnt/swapfile bs=1M count=2048
chown root:root /mnt/swapfile
chmod 600 /mnt/swapfile
/sbin/mkswap /mnt/swapfile
/sbin/swapon /mnt/swapfile
#Install Required Repos
yum --enablerepo=epel --disablerepo=amzn2-core -y install libwebp

#Update all libs
yum update -y

#Install Package Repos (REMI, EPEL)
yum -y remove php* httpd*

#Install Required Devtools
yum -y install gcc-c++ gcc pcre-devel make zip unzip wget curl cmake git yum-utils sudo

#Clear cache dir
rm -Rf /var/cache/yum/base/packages

#Make swap for performance
/bin/dd if=/dev/zero of=/mnt/swapfile bs=1M count=2048
chown root:root /mnt/swapfile
chmod 600 /mnt/swapfile
/sbin/mkswap /mnt/swapfile
/sbin/swapon /mnt/swapfile
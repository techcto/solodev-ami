#Install Mysql
yum remove -y mariadb mariadb-server mariadb-libs && sudo rm -rf /var/lib/mysql /etc/my.cnf
yum -y install mariadb-server mariadb mariadb-libs
chkconfig mariadb on
service mariadb start
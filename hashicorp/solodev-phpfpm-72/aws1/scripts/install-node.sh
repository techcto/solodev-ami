#Init
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
yum install -y --enablerepo=nodesource nodejs
npm config set prefix '/var/www/solodev/node_modules_global'
echo "export NODE_PATH=/var/www/solodev/node_modules_global/lib/node_modules" >>  "/var/www/solodev/node_modules_global/.npmrc"
echo "export PATH=$PATH:/var/www/solodev/node_modules_global/bin" >>  "/var/www/solodev/node_modules_global/.npmrc"
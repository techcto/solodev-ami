#Init
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
yum install -y --enablerepo=nodesource nodejs
npm config set prefix '/var/www/Solodev/node_modules_global'
echo "export NODE_PATH=/var/www/Solodev/node_modules_global/lib/node_modules" >>  "/var/www/Solodev/node_modules_global/.npmrc"
echo "export PATH=$PATH:/var/www/Solodev/node_modules_global/bin" >>  "/var/www/Solodev/node_modules_global/.npmrc"
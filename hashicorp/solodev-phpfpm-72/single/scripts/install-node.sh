#Init
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
yum install -y nodejs
npm config set prefix '/var/www/Solodev/node_modules_global'
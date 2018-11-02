curl -sL https://rpm.nodesource.com/setup_11.x | sudo -E bash -
yum install -y --enablerepo=nodesource nodejs

mkdir -p "/var/www/node_modules_global"
npm config set prefix "/var/www/node_modules_global"
npm install -g autoprefixer clean-css-cli npm-run-all postcss-cli postcss-discard-empty shx uglify-js 
npm install -g --unsafe-perm node-sass

mkdir /var/www/.npm
chown -Rf apache.apache /var/www/.npm
chmod -Rf 2770 /var/www/.npm
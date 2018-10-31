#Init
mkdir -p /var/www/solodev/clients/solodev/.node_modules_global
export PATH=/var/www/solodev/clients/solodev/.node_modules_global/bin:$PATH
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -

#Execute
npm config set prefix '/var/www/solodev/clients/solodev/.node_modules_global'
yum install -y --enablerepo=nodesource nodejs
npm install -g autoprefixer clean-css-cli nodemon npm-run-all postcss-cli postcss-discard-empty shx uglify-js node-sass
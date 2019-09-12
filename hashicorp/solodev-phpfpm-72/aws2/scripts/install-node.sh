curl -sL https://rpm.nodesource.com/setup_11.x | sudo -E bash -
yum install -y --enablerepo=nodesource nodejs

mkdir -p "/var/www/node_modules_global"
npm config set prefix "/var/www/node_modules_global"
npm install -g --unsafe-perm @fortawesome/fontawesome-free autoprefixer clean-css-cli gulp gulp-autoprefixer \
		gulp-clean gulp-clean-css gulp-concat gulp-rename gulp-sass gulp-uglify node-sass0

mkdir /var/www/.npm
chown -Rf apache.apache /var/www/.npm
chmod -Rf 2770 /var/www/.npm
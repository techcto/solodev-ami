curl -sL https://rpm.nodesource.com/setup_11.x | sudo -E bash -
yum install -y --enablerepo=nodesource nodejs

mkdir -p "/var/www/node_modules_global"
npm config set prefix "/var/www/node_modules_global"
npm install -g \
  @fortawesome/fontawesome-free@^5.4.0 \
  animate.css@^3.5.2 \
  baguettebox.js@^1.11.0 \
  bootstrap@^4.1.3 \
  bootstrap-validator@^0.11.9 \
  echo-js@^1.7.3 \
  jquery@^3.2.1 \
  lazyload@^2.0.0-beta.2 \
  popper.js@^1.14.4 \
  slick-carousel@^1.8.1 \
  autoprefixer@^9.5.1 \
  clean-css-cli@^4.3.0 \
  gulp@^4.0.2 \
  gulp-autoprefixer@^6.1.0 \
  gulp-clean@^0.4.0 \
  gulp-clean-css@^4.2.0 \
  gulp-concat@^2.6.1 \
  gulp-rename@^1.4.0 \
  gulp-sass@^4.0.2 \
  gulp-uglify@^3.0.2 \
  node-sass@^4.12.0

mkdir /var/www/.npm
chown -Rf apache.apache /var/www/.npm
chmod -Rf 2770 /var/www/.npm
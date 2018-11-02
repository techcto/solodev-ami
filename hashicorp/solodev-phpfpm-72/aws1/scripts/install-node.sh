# # Install Node.js 6.x repository
# curl -sL https://rpm.nodesource.com/setup_6.x | bash -

# # Install Node.js and npm
# yum install -y --enablerepo=nodesource nodejs

curl -sL https://rpm.nodesource.com/setup_11.x | sudo -E bash -
yum install -y --enablerepo=nodesource nodejs

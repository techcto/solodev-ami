#- IE: ./build.sh hashicorp/solodev-phpfpm-72/aws1/config solodev-cluster-aws1-packer.json
echo "Validating - $2"
./packer validate $1/$2
echo "Building - $2"
./packer build $1/$2
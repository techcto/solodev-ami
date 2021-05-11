#Install latest official release of Solodev
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
mkdir -p /tmp/Solodev
fn="$(aws s3 ls s3://solodev-release | sort | tail -n 1 | awk '{print $4}')"
aws s3 cp s3://solodev-release/$fn /tmp/Solodev/Solodev.zip
cd /tmp/Solodev/
unzip Solodev.zip
rm -Rf Solodev.zip
ls -al
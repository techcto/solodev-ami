mkdir C:\inetpub\Solodev
$fn = $(aws s3 ls s3://solodev-release | sort | Select-Object -Last 1).Split(' ')[-1]
aws s3 cp s3://solodev-release/$fn C:\inetpub\Solodev.zip
cd C:\inetpub\
7z x Solodev.zip
del Solodev.zip
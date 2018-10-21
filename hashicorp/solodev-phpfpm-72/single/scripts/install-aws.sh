#Install AWS CloudWatch 
cd /root
wget http://ec2-downloads.s3.amazonaws.com/cloudwatch-samples/CloudWatchMonitoringScripts-v1.1.0.zip
unzip CloudWatchMonitoringScripts-v1.1.0.zip
rm -f CloudWatchMonitoringScripts-v1.1.0.zip

#Add Cloudwatch to Crontab
(crontab -l 2>/dev/null; echo "*/5 * * * * /root/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --from-cron --auto-scaling") | crontab -
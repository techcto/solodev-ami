#Install AWS CloudWatch 
cd /root
wget http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip
unzip CloudWatchMonitoringScripts-1.2.1.zip
rm -f CloudWatchMonitoringScripts-1.2.1.zip

# mkdir -p /tmp/cwlogs
# echo "[general]" > /tmp/cwlogs/apache.conf
# echo "state_file=/var/awslogs/agent-state" >> /tmp/cwlogs/apache.conf
# echo "[/var/log/httpd/access_log]" >> /tmp/cwlogs/apache.conf
# echo "file = /var/log/httpd/access_log" >> /tmp/cwlogs/apache.conf
# echo "log_group_name = ${WebServerLogGroup}" >> /tmp/cwlogs/apache.conf
# echo "log_stream_name = {instance_id}/apache.log" >> /tmp/cwlogs/apache.conf
# echo "datetime_format = %d/%b/%Y:%H:%M:%S" >> /tmp/cwlogs/apache.conf

#Add Cloudwatch to Crontab
(crontab -l 2>/dev/null; echo "*/5 * * * * /root/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --from-cron --auto-scaling") | crontab -
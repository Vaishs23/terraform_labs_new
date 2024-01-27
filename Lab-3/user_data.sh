#!/bin/bash
yum -y update
yum -y install httpd

MYIP=`curl http://169.254.169.254/latest/meta-data/ami-id`
echo "<h2> Huhahaha Webserver with PrivateIP: $MYIP</h2><br>Built by Terraform external file" > /var/www/html/index.html
service httpd start
chkconfig httpd on
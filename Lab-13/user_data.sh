#!/bin/bash
yum -y update
yum -y install httpd

myip = `curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Build by the Power of <font color="red">Terraform</font></h2><br><p>
<font color="green">Server PrivateIP: <font color="aqua">$myip<br><br?
<font color="magneta">
<b> Version 1.0</br>
</body>
</html>
EOF

service httpd start
chkconfig httpd on
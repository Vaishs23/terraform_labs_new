yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold"> Built by the Power of Terraform</h2><br>

<b>Version 1.0</b>
</html>
EOF

service httpd start
chkconfig httpd on
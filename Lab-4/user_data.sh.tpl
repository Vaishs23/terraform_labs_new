#!/bin/bash
yum -y update
yum -y install httpd

MYIP=`curl http://169.254.169.254/latest/meta-data/ami-id`

cat <<EOF > /var/www/html/index.html

<html>
<h2>Built by the power of <font color="red">Terraform</font></h2><br>

Server Owner is: ${f_name} ${l_name} <br>

%{ for x in names~}
Hello to ${x} from ${f_name} <br>
%{endfor ~}

</html>
EOF
xx

service httpd start
chkconfig httpd on
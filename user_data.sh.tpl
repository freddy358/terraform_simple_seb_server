#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>

<h2>Buid by Terraform with gitHubAction <font color="red"> v0.14</font></h2><br>

Created by ${f_name} ${l_name} <br>

%{ for member in members ~}

Hello to ${member} from ${f_name}<br>

%{ endfor ~}

</html>
EOF

echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform with external Script!"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on 
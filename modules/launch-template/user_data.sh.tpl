#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl enable httpd
systemctl start httpd

aws s3 cp s3://${bucket_name}/${image_key} /var/www/html/website-image.jpg

cat > /var/www/html/index.html << 'HTML'
<html>
<head><title>ACS730 Final Project - ${environment}</title></head>
<body style="text-align:center;font-family:sans-serif;">
  <h1>ACS730 Final Project</h1>
  <h2>Student: Muskan</h2>
  <p>Environment: ${environment}</p>
  <img src="website-image.jpg" style="max-width:500px;">
  <p>Server: $(hostname)</p>
</body>
</html>
HTML
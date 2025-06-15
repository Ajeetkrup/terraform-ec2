#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
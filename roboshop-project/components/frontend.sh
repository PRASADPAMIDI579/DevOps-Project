#!/bin/bash

echo "Installing Nginx server"
yum install nginx -yum

echo "Download the fronend content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo "clean the old content"
rm -rf /usr/share/nginx/html/*
#!/bin/bash

echo "Installing Nginx server"
yum install nginx -y >/tmp/roboshop.log

echo "Download the frontend content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >/tmp/roboshop.log
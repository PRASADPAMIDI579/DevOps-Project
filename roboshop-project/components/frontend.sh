#!/bin/bash

source components/common.sh

echo "Installing Nginx server"
yum install nginx -y &>>$LOG_FILE
STAT $?

echo "Download the frontend content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE 
STAT $?

echo "clean old content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
STAT $?

echo "Extract frontend content"
cd /tmp
unzip -o frontend.zip &>>$LOG_FILE
STAT $?

echo "copy extracted content to Nginx path"
cp -r frontend-main/static/* /usr/share/nginx/html &>>$LOG_FILE
STAT $?

echo "copy Nginx Roboshop config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
STAT $?

echo "update roboshop config"
sed -i -e "/catalogue/ s/localhost/cataloguge.roboshop.internal" /etc/nginx/default.d/roboshop.conf 
STAT $?

echo "start nginx service"
systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE
STAT $?
 

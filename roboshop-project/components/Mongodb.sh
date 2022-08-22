#!/bin/bash

source components/common.sh

echo "Download Mongodb repo file"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE

echo "install MongoDB"
yum install -y mongodb-org

echo "update Mongodb Config file"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE

echo "start database"
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE

echo "Download schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE

echo "extract schema"
cd /tmp
unzip -o mongodb.zip &>>$LOG_FILE

echo "Load schema"
cd mongodb-main
mongo < catalouge.js &>>$LOG_FILE
mongo < users.js &>>$LOG_FILE




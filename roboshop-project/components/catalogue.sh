#!/bin/bash

source /components/common.sh

echo "setup NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE

echo "create app user"
useradd roboshop &>>$LOG_FILE

echo "download catalogue code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE

echo "extract catalogue code"
cd /tmp/
unzip -o catalogue.zip &>>$LOG_FILE

echo "clean old catalogue"
rm -rf /home/roboshop/catalogue $>>$LOG_FILE

echo "copy catalogue content"
cp -r catalogue-main /home/roboshop/catalogue &>>$LOG_FILE

echo "install nodejs depedendcies"
cd /home/roboshop/catalogue
npm install &>>$LOG_FILE

chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

echo "Update SystemD file"
sed -i -e 's/MONGO DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/SystemD.service &>>$LOG_FILE

echo "Setup Catalogue SystemD file"
mv /home/roboshop/catalogue/SystemD.service /etc/systemd/system/catalogue.service &>>LOG_FILE

echo "start catalogue"
systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE
systemctl start catalogue &>>LOG_FILE
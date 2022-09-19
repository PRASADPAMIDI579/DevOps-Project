#!/bin/bash

source components/common.sh

echo "setup NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
STAT $?

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE
STAT $?



echo "create app user"
useradd roboshop &>>$LOG_FILE
STAT $?

echo "download catalogue code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "extract catalogue code"
cd /tmp/
unzip -o catalogue.zip &>>$LOG_FILE
STAT $?

echo "clean old catalogue"
rm -rf /home/roboshop/catalogue $>>$LOG_FILE
STAT $?



echo "copy catalogue content"
cp -r catalogue-main /home/roboshop/catalogue &>>$LOG_FILE
STAT $?

echo "install nodejs depedendcies"
cd /home/roboshop/catalogue
npm install &>>$LOG_FILE
STAT $?

chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

echo "Update systemd file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>$LOG_FILE
STAT $?

echo "Setup Catalogue Systemd file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE
STAT $?

echo "start catalogue"
systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE
systemctl start catalogue &>>LOG_FILE

STAT $?

 
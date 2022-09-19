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

echo "download users code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "extract user code"
cd /tmp/
unzip -o user.zip &>>$LOG_FILE
STAT $?

echo "clean old user"
rm -rf /home/roboshop/user $>>$LOG_FILE
STAT $?



echo "copy user content"
cp -r user-main /home/roboshop/user &>>$LOG_FILE
STAT $?

echo "install nodejs depedendcies"
cd /home/roboshop/user
npm install &>>$LOG_FILE
STAT $?

chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

echo "Update systemd file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>$LOG_FILE
STAT $?

echo "Setup user systemd file"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>LOG_FILE
STAT $?

echo "start user"
systemctl daemon-reload &>>LOG_FILE
systemctl enable user &>>LOG_FILE
systemctl start user &>>LOG_FILE
STAT $?

 
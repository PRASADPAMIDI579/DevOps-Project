#!/bin/bash

source /roboshop-project/components/common.sh

echo "setup NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE
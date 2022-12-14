#!/bin/bash
source components/common.sh

echo "Configure YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
STAT $?

echo "install Rabbitmq & Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2-6-1.el7.x86_64.rpm rabbitmq-server -y &>>$LOG_FILE
STAT $?

echo "start rabbitmq server"
systemctl enable rabbitmq-server &>>LOG_FILE
systemctl start rabbitmq-server &>>LOG_FILE
STAT $?

echo "create application user"
rabbitmq list_users | grep roboshop
if [ $? -ne 0 ]; then
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
fi
STAT $?

echo "setup permissions for appuser"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
STAT $?

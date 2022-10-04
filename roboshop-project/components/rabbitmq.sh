#!/bin/bash
source components/common.sh

echo "Configure YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
STAT $?

echo "install rabbitmq & erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v25.1/erlang-25.1-1.el8.x86_64.rpm rabbitmq-server -y &>>$LOG_FILE
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
# rabbitmqctl set_user_tags roboshop administrator
# rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


# RabbitMQ comes with a default username / password as `guest`/`guest`. But this user cannot be used to connect. Hence we need to create one user for the application.

# 1. Create application user
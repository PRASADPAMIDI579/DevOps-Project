#/bin/bash
source components/common.sh

echo "configure redis repo"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
STAT $?

echo " Insstalling Redis"
yum install redis-6.2.7 -y &>>$LOG_FILE
STAT $?

echo "update redis configuration"
if [ -f /etc/redis.conf ]; then
    sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf &>>$LOG_FILE
elif [ -f /etc/redis.conf ]; then
    sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/redis/redis.conf &>>$LOG_FILE
fi
STAT $?

echo "start redis"
systemctl enable redis &>>$LOG_FILE
systemctl restart redis &>>$LOG_FILE
STAT $?


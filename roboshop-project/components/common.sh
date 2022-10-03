LOG_FILE=/tmp/roboshop.log
rm -f &>>$LOG_FILE

STAT() {
    if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCESS\e[0m"
else
    echo -e "\e[1;31mFAILURE\e[0m"
    exit 1
fi
}

NODEJS () {
COMPONENT=$1
echo "setup NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
STAT $?

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE
STAT $?

echo "create app user"
id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
useradd roboshop &>>$LOG_FILE
fi
STAT $?

echo "download ${COMPONENT} code"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "extract ${COMPONENT} code"
cd /tmp/
unzip -o ${COMPONENT}.zip &>>$LOG_FILE
STAT $?

echo "clean old user"
rm -rf /home/roboshop/${COMPONENT} $>>$LOG_FILE
STAT $?



echo "copy ${COMPONENT}content"
cp -r ${COMPONENT}-main /home/roboshop/${COMPONENT} &>>$LOG_FILE
STAT $?

echo "install nodejs depedendcies"
cd /home/roboshop/${COMPONENT}
npm install &>>$LOG_FILE
STAT $?

chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

echo "Update ${COMPONENT} systemd file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal' -e 's/CATALOGUE_ENDPOINT/catlogue.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
STAT $?

echo "Setup ${COMPONENT} Systemd file"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>LOG_FILE
STAT $?

echo "start ${COMPONENT} service"
systemctl daemon-reload &>>LOG_FILE
systemctl enable ${COMPONENT} &>>LOG_FILE
systemctl restart ${COMPONENT} &>>LOG_FILE
STAT $?
}
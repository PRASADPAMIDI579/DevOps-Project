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

APP_USER_SETUP_WITH_APP() {

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

echo "clean old ${COMPONENT}"
rm -rf /home/roboshop/${COMPONENT} $>>$LOG_FILE
STAT $?

echo "copy ${COMPONENT}content"
cp -r ${COMPONENT}-main /home/roboshop/${COMPONENT} &>>$LOG_FILE
STAT $?

}

SYSTEMD_SETUP() {
chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

echo "Update ${COMPONENT} systemd file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop
.internal/' -e 's/CATALOGUE_ENDPOINT/catlogue.roboshop.internal/' -e 's/CARTENDPOINT/cart/roboshop.internal/' -e 's/DBHOST/mysql.roboshop
.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.inetrnal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
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


NODEJS () {
COMPONENT=$1
echo "setup NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
STAT $?

echo "Install Nodejs"
yum install nodejs -y &>>$LOG_FILE
STAT $?

APP_USER_SETUP_WITH_APP

echo "install nodejs depedendcies"
cd /home/roboshop/${COMPONENT}
npm install &>>$LOG_FILE
STAT $?

SYSTEMD_SETUP

}

JAVA() {
    COMPONENT=$1
     
    echo "Install Maven"
    yum install maven -y &>>$LOG_FILE

    APP_USER_SETUP_WITH_APP

    echo "Compile ${COMPONENT} Code"
    cd /home/roboshop/${COMPONENT}
    mvn clean package &>>$LOG_FILE
    mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
    STAT $?
}

PYTHON() {
    COMPONENT=$1
     
    echo "Install python"
    yum install python36 gcc python3-devel -y &>>$LOG_FILE
    STAT $?

    APP_USER_SETUP_WITH_APP

    echo "install python dependencies for ${COMPONENT}"
    cd /home/roboshop/payment 
    pip3 install -r requirements.txt &>>$LOG_FILE    
    STAT $?

    echo "update application config"
    USER_ID=$(id -u roboshop)
    GROUP_ID=$(id -g roboshop)
    sed -i -e "/uid/ c uid = ${USER_ID}" -e "/gid/ c gid = ${GROUP_ID}" /home/roboshop/${COMPONENT}/${COMPONENT}.ini
    STAT $?

SYSTEMD_SETUP
}

GOLANG() {
    COMPONENT=$1
     
    echo  "install golang"
    yum install golang -y &>>$LOG_FILE
    STAT $?

    APP_USER_SETUP_WITH_APP

    echo "Build GOLANG Code"
    echo /home/roboshop/${COMPONENT} 
    go mod init dispatch &>>$LOG_FILE
    go get &>>$LOG_FILE
    go build &>>$LOG_FILE
    STAT $?
}













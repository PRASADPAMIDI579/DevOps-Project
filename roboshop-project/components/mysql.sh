

# ## **Setup Needed for Application.**

# As per the architecture diagram, MySQL is needed by

# - Shipping Service

# So we need to load that schema into the database, So those applications will detect them and run accordingly.

# To download schema, Use the following command

# ```bash
# # curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
# ```

# Load the schema for Services.

# ```bash
# # cd /tmp
# # unzip mysql.zip
# # cd mysql-main
# # mysql -u root -pRoboShop@1 <shipping.sql
# ```

source components/common.sh

echo "setting up mysql repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
STAT $?

echo "install mysql server"
yum install mysql-community-server -y &>>$LOG_FILE
STAT $?

echo "start mysql service"
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
STAT $?

DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Roboshop@1');
uninstall plugin validate_password;" >/tmp/pass.sql

echo "change default password"
echo 'show databases;' | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ $? -ne 0 ]; then
mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/pass.sql &>>$LOG_FILE
fi
STAT $?

echo "Download mysql shipping schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE
STAT $?

echo "extract schema file"
cd /tmp
unzip -o mysql.zip &>>$LOG_FILE
STAT $?

echo "Load Schema"
mysql -u root -pRoboShop@1 <mysql-main/shipping.sql &>>$LOG_FILE
STAT $?

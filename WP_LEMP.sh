#!/bin/bash
RED='\033[0;31m'; # Red Color
GREEN='\033[0;32m';#Green Color
NC='\033[0m'; # No Color
bold=$(tput bold);
normal=$(tput sgr0);
clear;
echo "Please wait . . .";
sudo apt-get install w3m -y > /dev/null;

read -p "Please enter domain name of your wordpress webiste: " dname;
#replace '.' from domain name to '_' for database setup
dbConf=${dname//./_};

#install openssl if not installed to generate random Password
sudo apt-get install openssl > /dev/null;
epwd=$(openssl rand -base64 8);

clear;
echo "Please wait . . .";
sudo apt-get autoremove -y > /dev/null;

#MySql installation
echo -e "\n\nChecking for mysql...";
output=$(type -t mysqld);
if [ "$output" = "file" ];
then
printf "\t${GREEN}* ${NC}";
echo "Mysql is Installed";
sleep 2;
else
clear;
echo "Mysql is not installed, Installing Mysql...";
echo -e "\tPlease Wait..."
chmod +x install_mysql_server.sh;
./install_mysql_server.sh;
output=$(type -t mysqld);
  if [ "$output" = "file" ];
  then
    printf "\t${GREEN}* ${NC}";
    echo " Mysql is Installed";
    sleep 2;
  else
    printf "${RED}Problem Installing Mysql... Sorry for the inconvinience...${NC}";
    sleep 2;
    exit 1;
  fi
fi

#Nginx installation
echo -e "\n\nChecking for Engine-X (nginx)...";
output=$(type -t nginx);
if [ "$output" = "file" ];
then
printf "\t${GREEN}* ${NC}";
echo "Nginx is Installed";
else
echo "Nginx is not installed, Installing Nginx";
echo -e "\tPlease Wait...";
chmod +x install_nginx_server.sh;
./install_nginx_server.sh;
output=$(type -t nginx);
  if [ "$output" = "file" ];
    then
      printf "\t${GREEN}* ${NC}";
      echo "Nginx is Installed";
    else
      printf "${RED}Problem Installing NGINX... Sorry for the inconvinience...${NC}";
      sleep 2;
      exit 1;
  fi
echo -e "\nInstalling required PHP modules...";
#run script to install php modules
chmod +x install_php_modules.sh
./install_php_modules.sh
fi


#start mysql server
sudo service mysql start;
#check if same database and user exists and create new onw if exists
tst=1;
while
ts=("$dbConf"_"$tst");
check=$(sudo mysql -e "SHOW DATABASES LIKE '$ts'");
[ "$check" != "" ];
  do
  tst=$(expr $tst + 1);
  done
dbConf=("$dbConf"_"$tst");
#mysql command to create new user with same database name and randomly generated password
sudo mysql -e "CREATE USER '$dbConf'@'localhost' IDENTIFIED BY '$epwd'; CREATE DATABASE IF NOT EXISTS $dbConf; GRANT ALL PRIVILEGES ON $dbConf.* TO '$dbConf'@'localhost'; FLUSH PRIVILEGES;";



#downloading and installing wordpress & fixing file permissions to run wordpress smoothly
echo -e "\n\nDownloading Wordpress...";
wget https://wordpress.org/latest.tar.gz -O latest.tar.gz;
clear;

#Backup Existing files
timestamp=$(date +%s);
echo "Backing up files...";
sudo mkdir -p /var/www/backups/$timestamp
sudo mv /var/www/html/* /var/www/backups/$timestamp
printf "${GREEN}* ${NC}";
echo "Backup compleate, stored at ${bold}/var/www/backups/${normal}";
sleep 2;
clear;

echo "Extracting Files...";
sudo tar -xzf latest.tar.gz -C /var/www/html/;
sleep 2;
clear;

echo "Installation is in progress...";
sudo mv /var/www/html/wordpress/* /var/www/html/;
sudo rm -r /var/www/html/wordpress;
sleep 2;
clear;

echo "Managing Permissions and finishing installation";
sudo find /var/www/html -type d -exec chmod 755 {} \;
sudo find /var/www/html -type f -exec chmod 644 {} \;
sudo chown www-data:www-data -R /var/www/html;
printf "${GREEN}Done.${NC}";
sleep 2;
clear;

#Adding host entery in /etc/hosts
echo "127.0.0.1 $dname" | sudo tee -a /etc/hosts > /dev/null;

#restart nginx server
sudo systemctl restart nginx.service > /dev/null;
echo "Thank you for choosing us for wordpress installation, Installation is compleate. ";
printf "${RED}*******************************************${NC}\n";
echo "Use following steps & credentials for initial setup of your website";
echo -e "1) Go to $dname from your web browser";
echo -e "\t(use command ${bold} w3m $dname ${normal} if you are using terminal)";
echo -e "2) Wordpress will ask you to configure databse, click ${bold}[ let's go! ]${normal} ";
echo -e "3) Enter following data in fields: ";
echo -e "\tDatabase Name : ${bold} $dbConf ${normal}";
echo -e "\tUsername : ${bold} $dbConf ${normal}";
echo -e "\tPassword : ${bold} $epwd ${normal}";
echo -e "\tDatabase Host :${bold} localhost ${normal}";
echo -e "\tTable Prefix : ${bold} wp_ ${normal} (you can keep it as it is)";
echo -e "4) Click On ${bold}Submit${normal} button";
printf "${RED}*******************************************${NC}\n";
echo "you can use command [${bold} curl ifconfig.me ${normal}] to get public IP of your server to visit it remotely from web browser";

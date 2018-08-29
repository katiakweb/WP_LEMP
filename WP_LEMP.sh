#!/bin/bash
RED='\033[0;31m'; # Red Color
NC='\033[0m'; # No Color
bold=$(tput bold);
normal=$(tput sgr0);

echo "Please wait . . .";
sudo apt-get install w3m -y > /dev/null;

read -p "Please enter domain name of your wordpress webiste: " dname;
read -p "Enter a password for project database: " epwd;
read -p "Re-enter a password for verification : " cpwd;

#replace '.' from domain name to '_' for database setup
dbConf=${dname//./_};

while [ ! "$epwd" = "$cpwd"  ]
do
clear;
echo "Project: $dname";
printf "${RED}Password and verification passwords are different${NC} , please retry ";
read -p "Enter a password for project database: " epwd;
read -p "Re-enter a password for verification : " cpwd;
done

sudo apt-get autoremove -y;

#MySql installation
echo "Checking for mysql...";
output=$(type -t mysqld);
if [ "$output" = "file" ];
then
echo "Mysql is Installed";
else
echo "Mysql is not installed, Installing Mysql...";
chmod +x install_mysql_server.sh;
./install_mysql_server.sh;
fi

#Nginx installation
echo "Checking for Nginx...";
output=$(type -t nginx);
if [ "$output" = "file" ];
then
echo "Nginx is Installed";
else
echo "Nginx is not installed, Installing Nginx";
chmod +x install_nginx_server.sh;
./install_nginx_server.sh;
fi


#start mysql server
sudo service mysql start;
#mysql command to create new user with same database name
sudo mysql -e "CREATE USER '$dbConf'@'localhost' IDENTIFIED BY '$epwd'; CREATE DATABASE IF NOT EXISTS $dbConf; GRANT ALL PRIVILEGES ON $dbConf.* TO '$dbConf'@'localhost'; FLUSH PRIVILEGES;";



#downloading and installing wordpress & fixing file permissions to run wordpress smoothly
echo "Downloading Wordpress...";
wget https://wordpress.org/latest.tar.gz -O latest.tar.gz;
clear;

#Backup Existing files
timestamp=$(date +%s);
echo "Backing up files...";
sudo mkdir -p /var/www/backups/$timestamp
sudo mv /var/www/html/* /var/www/backups/$timestamp
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
echo "Done.";
sleep 2;
clear;

echo "127.0.0.1 $dname" | sudo tee -a /etc/hosts > /dev/null;

#restart nginx server
sudo systemctl restart nginx.service > /dev/null;
echo "Thank you for choosing us for wordpress installation, Installation is compleate. ";
printf "${RED}*******************************************${NC}";
echo "";
echo "Use following steps & credentials for initial setup of your website";
echo "1) Go to $dname from your web browser";
echo "	(use command ${bold} w3m $dname ${normal} if you are using terminal)";
echo "2) Wordpress will ask you to configure databse, click ${bold}[ let's go! ]${normal} ";
echo "3) Enter following data in fields: ";
echo "		Database Name : ${bold} $dbConf ${normal}";
echo "		Username : ${bold} $dbConf ${normal}";
echo "		Password : ${bold} $epwd ${normal}";
echo "		Database Host :${bold} localhost ${normal}";
echo "		Table Prefix : ${bold} wp_ ${normal} (you can keep it as it is)";
echo "4) Click On ${bold}Submit${normal} button";
printf "${RED}*******************************************${NC}";
echo "";
echo "you can use command [${bold} curl ifconfig.me ${normal}] to get public IP of your server to visit it remotely from web browser";

#!/bin/bash

#to install nginx server and without prompts
sudo apt-get install nginx -y > /dev/null;

#to  install php-fpm and php mysql required for lemp stack
sudo apt-get install software-properties-common -y > /dev/null;
sudo apt-add-repository ppa:ondrej/php -y > /dev/null;
sudo apt-get update -y > /dev/null;
sudo apt-get upgrade -y > /dev/null;

sudo apt-get install php7.2 php7.2-fpm php7.2-mysql -y > /dev/null;

#add following php modules if you want to install wordpress
sudo apt install php7.2-gettext php7.2-curl php7.2-zip mcrypt php7.2-gd php7.2-mbstring php7.2-xmlrpc php7.2-xml -y > /dev/null;

# Restart php-fpm for php modules to be activated:
sudo service php7.2-fpm restart;



#stop apache server if running and disable autostart if it's pre installed
sudo service apache2 stop;
sudo systemctl disable apache2;
sudo rm -r /var/www/html/index.html;

#Setup nginx
#backup default configuration for failsafe
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
#write nginx configuration to configuration file /etc/nginx/sites-available/default
chmod +x nginx_config.sh
sudo ./nginx_config.sh 

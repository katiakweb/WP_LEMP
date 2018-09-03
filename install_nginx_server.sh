#!/bin/bash

#to install nginx server and without prompts
sudo apt-get install nginx -y > /dev/null;

#to  install php-fpm and php mysql required for lemp stack
sudo apt-get install software-properties-common -y > /dev/null;
sudo apt-add-repository ppa:ondrej/php -y > /dev/null;
sudo apt-get update -y > /dev/null;
sudo apt-get upgrade -y > /dev/null;



#Setup nginx
#backup default configuration for failsafe
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
#write nginx configuration to configuration file /etc/nginx/sites-available/default
chmod +x nginx_config.sh
sudo ./nginx_config.sh

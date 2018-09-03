#!/bin/bash

#To install mysql server and MySql client V5.7
sudo apt-get install mysql-server-5.7 mysql-client-5.7 -y > /dev/null;
read -p "Do you want to setup mysql root [y/n] : " answer;

if [ "$answer" = "y" -o "$answer" = "Y" ]; then
sudo mysql_secure_installation;
fi

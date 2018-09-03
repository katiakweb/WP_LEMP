
#we are installing php v7.2 along with required php modules if they are not installed
sudo apt-get install php7.2 php7.2-fpm php7.2-mysql -y > /dev/null;
#following php modules are required to install wordpress
sudo apt install php7.2-gettext php7.2-curl php7.2-zip php7.2-gd php7.2-mbstring php7.2-xmlrpc php7.2-xml -y > /dev/null;

# Restart php-fpm for php modules to be activated:
sudo service php7.2-fpm restart;

#Sometimes php installation installs Apache2 server by default with an installation just stop & disable apache2 service
#stop apache server if running and disable autostart if it's pre installed
sudo service apache2 stop > /dev/null;
sudo systemctl disable apache2 > /dev/null;
#remove apache2 home page from server root it's not nessesory but better to remove to avoid confusions
sudo rm -r /var/www/html/index.html > /dev/null;

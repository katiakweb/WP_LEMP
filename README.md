# WP_LEMP
###### Automated shell script for installation of Latest version of Wordpress on LEMP [Linux,Engine-X,MySql, PHP] stack on a linux (ubuntu) server

##### Steps to use
	1. git clone https://github.com/rauthardik/WP_LEMP
	2. cd WP_LEMP
	3. chmod +x WP_LEMP.sh
	4. ./WP_LEMP
![usage_info](https://github.com/rauthardik/WP_LEMP/blob/master/ezgif.com-gif-maker.gif)

	* please use valid domain names eg. "example.com", "example1.com", "demo.com" etc.
	* default server root location is "/var/www/html/"
	* every new install made on server root directory i.e. "/var/www/html/",
	however all data from that directory is backed up in "/var/www/backups/"
	* Nginx config gets automatically written , but for wordpress configuration,
	all configuration data & instructions are displayed to the user to configure wordpress from web UI
	this is done in order to allow worpress to generate security salts.
	
Thank You !

* Note : this version is only tested on ubuntu server 18.04 please report if you found any issues.

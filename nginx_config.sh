echo 'server {' > /etc/nginx/sites-available/default
echo 'listen  80 default_server;' >> /etc/nginx/sites-available/default
echo 'listen [::]:80 default_server;' >> /etc/nginx/sites-available/default
echo 'server_name  _;' >> /etc/nginx/sites-available/default
echo 'root /var/www/html;' >> /etc/nginx/sites-available/default
echo 'index index.php index.html;' >> /etc/nginx/sites-available/default
echo ''  >> /etc/nginx/sites-available/default
echo ''   >> /etc/nginx/sites-available/default
echo '	location ~ \.php$ {' >> /etc/nginx/sites-available/default
echo '			include snippets/fastcgi-php.conf;' >> /etc/nginx/sites-available/default
echo '			fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;' >> /etc/nginx/sites-available/default
echo '			#fastcgi_index index.php;' >> /etc/nginx/sites-available/default
echo '			#fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/sites-available/default
echo '			#include fastcgi_params;' >> /etc/nginx/sites-available/default
echo '			}' >> /etc/nginx/sites-available/default
echo '}' >> /etc/nginx/sites-available/default

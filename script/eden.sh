again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1. Create virtulahost                                           ";
echo " 2. Config webserver                                             ";
echo " 0. Exit                                                         ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 1] : " choice;
echo "";
case $choice in

1)  if [ -z "$(ls -A /etc/apache2/sites-available/000-default.conf)" ]; then
        echo "File not found"
        else
        echo "Configure..."
        cat > /etc/apache2/sites-available/000-default.conf <<- EOF

#wise.D14.com
<VirtualHost *:80>
        ServerName wise.D14.com
        ServerAlias www.wise.D14.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.D14.com

        <Directory /var/www/www.D14.com/index.php/home>

        Options +Indexes
        </Directory> 
        Alias "/home" "/var/www/www.D14.com/index.php/index.php/home"

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

#eden.wise.D14.com
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.D14.com
        ServerName www.eden.wise.D14.com
        Alias "/js" "/var/www/eden.wise.D14.com/public/js" 
        
        <Directory /var/www/eden.wise.D14.com/public>
                Options +Indexes
        </Directory>
        <Directory /var/www/eden.wise.D14.com/public/css/*>
                Options -Indexes
        </Directory>
        <Directory /var/www/eden.wise.D14.com/public/js/*>
                Options -Indexes
        </Directory>
        <Directory /var/www/eden.wise.D14.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
        
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

        cat /etc/apache2/sites-available/000-default.conf
        service apache2 restart
        echo "Done..."
        fi
        ;;

2)  if [ -z "$(ls -A /var/www/html)" ]; then
        echo "Apache2 is not installed"
        else
        echo "Copy file to /var/www/html..."
        # git clone https://github.com/danielcristho/Jarkom-Modul-2-D14-2022.git
        echo "Copy file to /var/www/html..."
        cp Jarkom-Modul-2-D14-2022/src/wise/ /var/www/wise.D14.com -r
        cp Jarkom-Modul-2-D14-2022/src/eden.wise/ /var/www/eden.wise.D14.com/ -r
        cp Jarkom-Modul-2-D14-2022/src/strix.operation.wise/ /var/www/strix.operation.wise.D14.com -r
        echo "edit .htaccess"
        touch /var/www/eden/wise.D14.com/.htaccess
        echo "ErrorDocument 404 /error/404.html" > /var/www/eden/wise.D14.com/.htaccess
        echo "Done..."
        fi
        ;;

0)  exit
    ;;
*)    echo "sorry, menu is not found"
esac
echo -n "Back again? [y/n]: ";
read again;
while [[ $again != 'Y' ]] && [[ $again != 'y' ]] && [[ $again != 'N' ]] && [[ $again != 'n' ]];
do
echo "Your input is not correct";
echo -n "back again? [y/n]: ";
read again;
done
done
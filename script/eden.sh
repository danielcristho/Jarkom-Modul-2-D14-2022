again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1. Config webserver & apache                                    ";
echo " 2. Config virtulahost(wise.D14.com.conf)                        ";
echo " 3. Config virtulahost(eden.wise.D14.com.conf)                   ";
echo " 4. Config virtulahost(operation.strix.wise.D14.com.conf)        ";
echo " 0. Exit                                                         ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 4] : " choice;
echo "";
case $choice in

1)  if [ -z "$(ls -A /var/www/html)" ]; then
        echo "Apache2 is not installed"
        else
        echo "Copy file to /var/www/..."
        cd /root
        # git clone https://github.com/danielcristho/Jarkom-Modul-2-D14-2022.git
        echo "Copy file to /var/www/..."
        cp Jarkom-Modul-2-D14-2022/src/wise/ /var/www/wise.D14.com -r
        cp Jarkom-Modul-2-D14-2022/src/eden.wise/ /var/www/eden.wise.D14.com/ -r
        cp Jarkom-Modul-2-D14-2022/src/strix.operation.wise/ /var/www/strix.operation.wise.D14.com -r
        echo "create .htaccess(wise.D14.com)"
        touch /var/www/wise.D14.com/.htaccess
        echo "ErrorDocument 404 /error/404.html" > /var/www/eden/wise.D14.com/.htaccess
        echo "create .htaccess(wise.D14.com)"
        touch /var/www/strix.operation.wise.D14.com/.htaccess
        echo "AuthType Basic
AuthName "Restricted Content"
AuthUserFile /var/www/strix.operation.wise.D14.com/.htpasswd
Require valid-user" > /var/www/strix/operation.wise.D14.com

        echo "create .htpasswd"
        htpasswd -c -b /var/www/strix.operation.wise.D14.com/.htpasswd Twilight opStrix
        echo "create new apache configuration"
        touch /etc/apache2/sites-available/wise.D14.com.conf
        touch /etc/apache2/sites-available/eden.wise.D14.com.conf
        touch /etc/apache2/sites-available/strix.operation.wise.D14.com.conf
        echo "Done..."
        fi
        ;;

2)  if [ -z "$(ls -A /etc/apache2/sites-available/wise.D14.com.conf)" ]; then
        echo "File not found"
        else
        echo "Configure..."
        cat > /etc/apache2/sites-available/wise.D14.com.conf <<- EOF
#wise.D14.com
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.D14.com
        ServerName www.wise.D14.com

        Alias "/home" "/var/www/wise.D14.com/index.php/home"

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
#Redirect http
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/franky.A16.com
        ServerName http://192.192.2.3

        Redirect 301 / http://www.wise.D14.com/

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

        cat /etc/apache2/sites-available/wise.D14.com.conf
        a2ensite wise.D14.com
        service apache2 reload
        echo "Done..."
        fi
        ;;

3)  if [ -z "$(ls -A /etc/apache2/sites-available/eden.wise.D14.com.conf)" ]; then
        echo "File not found"
        else
        echo "Configure..."
        cat > /etc/apache2/sites-available/eden.wise.D14.com.conf <<- EOF
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
        cat /etc/apache2/sites-available/eden.wise.D14.com.conf
        a2ensite eden.wise.D14.com
        service apache2 reload
        echo "Done..."
        fi
        ;;


4)  if [ -z "$(ls -A /etc/apache2/sites-available/strix.operation.wise.D14.com.conf)" ]; then
        echo "File not found"
        else
        echo "Configure..."
        cat > /etc/apache2/sites-available/strix.operation.wise.D14.com.conf <<- EOF
#strix.operation.wise.D14.com
<VirtualHost *:15000 *:15500>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.D14.com
        ServerName www.strix.operation.wise.D14.com

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/strix.operation.wise.D14.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
                Require all granted
        </Directory>

</VirtualHost>
EOF
        cat /etc/apache2/sites-available/strix.operation.wise.D14.com.conf
        echo "Listen 15000
Listen 15500" >> /etc/apache2/ports.conf
        a2ensite strix.operation.wise.D14.com
        service apache2 reload
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
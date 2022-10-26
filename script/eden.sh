#!/bin/bash
cd /etc/apache2/sites-available
cp 000-default.conf wise.D14.com.conf
echo ‘<VirtualHost *:80>

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
</VirtualHost> ’ > /etc/apache2/sites-available/wise.D14.com.conf



again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1. Create virtulahost                                           ";
echo " 0. Exit                                                         ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 1] : " choice;
echo "";
case $choice in

1)  if [ -z "$(ls -A /var/www/wise.D14.com)" ]; then
        echo "File not found"
        else
        echo "Configure..."
        cat > /var/www/wise.D14.com <<- EOF

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
EOF

        cat /etc/bind/named.conf.options
        service apache2 restart
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
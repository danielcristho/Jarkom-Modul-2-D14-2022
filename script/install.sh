#!/bin/bash

again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1.  Update machine                                              ";
echo " 2.  Upgrade machine                                             ";
echo " 3.  Install Bind9                                               ";
echo " 4.  Install dependencies                                        ";
echo " 5.  Install Nginx                                               ";
echo " 6.  Install Apache2                                             ";
echo " 7.  Install PHP8.0                                              ";
echo " 8.  Install PHP8.1                                              ";
echo " 9.  Set up iptables                                             ";
echo " 10. Setup Apache2 (edit index.html)                             ";
echo " 11. Restart machine                                             ";
echo " 12. Set resolv.conf                                             ";
echo " 0.  Exit                                                        ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 12] : " choice;
echo "";
case $choice in

1)  read -p "You will update this machine? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get update -y
    echo "Update success"
    fi
    ;;

2)  read -p "You will upgrade this machine? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt upgrade -y
    echo "Upgrade success"
    fi
    ;;

3)  read -p "You want install bind9? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install bind9 -y
    echo "Install success"
    fi
    ;;

4)  read -p "You want install many dependecies? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install nano net-tools dnsutils iputils-ping openssh-server vim iproute2 iptables git curl lynx -y
    echo "Install success"
    fi
    ;;

5)  read -p "You want install Nginx? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install nginx -y
    apt-get install lynx -y
    echo "Nginx is ready to use"
    fi
    ;; 

6)  read -p "You want install Apache? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install apache2 -y
    echo "Apache is ready to use"
    fi
    ;; 


7)  read -p "You want install PHP8.0? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    echo "Add PHP Repository"
    add-apt-repository ppa:ondrej/php
    apt update -y
    apt-get install php8.0-common php8.0-cli php8.0-mbstring php8.0-xml php8.0-curl php8.0-mysql php8.0-fpm -y
    echo "PHP is ready to use"
    fi
    ;;

8)  read -p "You want install PHP8.1? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    echo "Add PHP Repository"
    add-apt-repository ppa:ondrej/php
    apt update -y
    apt-get install php8.1-common php8.1-cli php8.1-mbstring php8.1-xml php8.1-curl php8.1-mysql php8.1-fpm -y
    echo "PHP is ready to use"
    fi
    ;;

9)  read -p "You want set up iptables? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    iptables -t nat -A POSTROUTING -j MASQUERADE -o eth0 -s 192.192.0.0/16
    echo "iptables -t nat -A POSTROUTING -j MASQUERADE -o eth0 -s 192.192.0.0/16" >> /root/.bashrc
    fi
    ;;

10) read -p "You want set up Apache2? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    systemctl status apache2 | grep Active
    echo "Edit index.html"
    cd /var/www/html/
    chown -R www-data:www-data .
    echo '<h1>Welcome to Server 1</h1>' > index.html
    service apache2 restart
    fi
    ;;

11) read -p "You want restart this machine? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    reboot
    fi
    ;;

12) read -p "You want resolv.conf? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    echo "nameserver 192.168.122.1" >> /etc/resolv.conf
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
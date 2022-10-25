#!/bin/bash

#CONSTANT
SERVER_ADDR="192.192.3.2"
DOMAIN_NAME="wise.d14.com"
FORWARD_FILE="forward"
REVERSE_FILE="reverse"
RESOLV_ADDR="3.192.192"

again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]];
do
clear
echo "=================================================================";
echo " 1. Update machine                                               ";
echo " 2. Upgrade machine                                              ";
echo " 3. Install bind9                                                ";
echo " 4. Create new zone (forward zone&reverse zone)                  ";
echo " 5. Configure forward zone                                       ";
echo " 6. Configure reverse zone                                       ";
echo " 7. Configure named.conf.options                                 ";
echo " 8. Configure resolv.conf                                        ";
echo " 9. Remove bind9                                                 ";
echo " 0. Exit                                                         ";
echo "=================================================================";

read -p " Enter Your Choice [0 - 9] : " choice;
echo "";
case $choice in

1)  read -p "You will update and install many dependencies? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt update -y
    apt-get install net-tools -y
    apt-get install lynx dnsutils -y
    echo "Update success"
    fi
    ;;

2)  read -p "You will upgrade this machine? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt upgrade -y
    echo "Upgrade success"
    fi
    ;;

3)  read -p "You want install bind9? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get install bind9 -y
    echo "Bind9 is ready to use"
    fi
    ;;

4)  if [ -z "$(ls -A /etc/bind/named.conf)" ]; then
    echo "Bind9 is not installed before, Please install it!"
    else
    echo "Created forward zone and reverse zone"
    # sudo su
    cat >> /etc/bind/named.conf <<- EOF

zone "${DOMAIN_NAME}" {
        type master;
        file "/etc/bind/wise/${FORWARD_FILE}";
};
zone "${RESOLV_ADDR}.in-addr.arpa" {
        type master;
        file "/etc/bind/wise/${REVERSE_FILE}";
};
EOF
    cat /etc/bind/named.conf

    echo "Create new forward and reverse file"
    cd /etc/bind && mkdir wise
    cp db.local wise/${FORWARD_FILE}
    cp db.127 wise/${REVERSE_FILE}
    echo "Done..."
    fi
    ;;

5)  if [ -z "$(ls -A /etc/bind/wise/${FORWARD_FILE})" ]; then
    echo "File not found!!"
    else
    cd /etc/bind/wise
    echo "Replace all localhost string with domain name..."
    sed -i "s/localhost/${DOMAIN_NAME}/gI" ${FORWARD_FILE}
    echo "Replace 127.0.0.1 with server address..."
    sed -i "s/127.0.0.1/${SERVER_ADDR}/gI" ${FORWARD_FILE}
    echo "Adding new record..."
    cat >> /etc/bind/${FORWARD_FILE} <<- EOF
www     IN      A       $SERVER_ADDR
EOF
    cat /etc/bind/wise/${FORWARD_FILE}
    echo "Done..."
    fi
    ;;

6)  if [ -z "$(ls -A /etc/bind/wise/${REVERSE_FILE})" ]; then
    echo "File not found!!"
    else
    cd /etc/bind/wise
    echo "Replace all localhost string with domain name..."
    sed -i "s/localhost/${DOMAIN_NAME}/gI" ${REVERSE_FILE}
    echo "Adding new record..."
    cat >> /etc/bind/${REVERSE_FILE} <<- EOF
2       IN        NS         $DOMAIN_NAME.
2      IN       PTR         www.$DOMAIN_NAME.

EOF
    cat /etc/bind/${REVERSE_FILE}
    service bind9 restart
    echo "Configurations is succes..."
    fi
    ;;

7)  if [ -z "$(ls -A /etc/bind/named.conf.options)" ]; then
    echo "File not found"
    else
    echo "Configure..."
    # sudo su
    cat >> /etc/bind/named.conf <<- EOF

options {
        directory "/var/cache/bind";
        // forwarders {
        //      0.0.0.0;
        // };
        // dnssec-validation auto;
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
EOF
    cat /etc/bind/named.conf.options
    service bind9 restart
    echo "Done..."
    fi
    ;;

8)  read -p "You want set up resolv.conf? y/n : " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    echo "Edit resolv.conf"
    # sudo su
    echo "nameserver ${SERVER_ADDR}" > /etc/resolv.conf
    #Comment IP Nat
    echo "#nameserver 192.168.122.1" >> /etc/resolv.conf
    echo "DONE..."
    echo "Try using nslookup..."
    fi
    ;;

9)  read -p "You want  to remove bind9 and all config files? y/n :" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]
    then 
    apt-get remove bind9 -y
    apt-get remove --auto-remove bind9 -y
    echo "Bind9 is already remove"
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
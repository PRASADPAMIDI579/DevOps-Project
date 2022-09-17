#!/bin/bash

 ID=$(id -u)
 if [ $ID -ne 0 ]; then
    echo -e "\e[1;31m You should be root usetr to excute this script..\e[0m"
    exit 1
fi

if [ -f components/$1.sh ]; then
bash components/$1.sh
else
    echo -e "\e[1;31mInvalid Input\e[0m"
    echo -e "\e[1;33mAvailable Inputs - frontend|mongodb|catalogue|redis|users|cart|mysql|shipping|payment|rabbitmq|dispatch\e[0m"
    exit 1
fi
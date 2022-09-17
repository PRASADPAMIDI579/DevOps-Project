#!/bin/bash

if [ -f components/$1.sh ]; then
bash components/$1.sh
else
    echo -e "\e31mInvalid Input\e[0m"
    echo -e "\e33mAvailable Inputs - frontend|mongodb|catalogue|redis|users|cart|mysql|shipping|payment|rabbitmq|dispatch\e[0m"
fi
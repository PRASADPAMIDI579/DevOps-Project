#!/bin/bash

INSTANCE_NAME=$1
if [ -z "${INSTANCE_NAME}" ]; then
    echo -e "\e[1;33mInstance Name Argument is needed\e[0m"
    exit
fi    

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" --query 'Images[*].[ImageId]' --output text)
if [ -z "${AMI_ID}" ]; then
    echo -e "\e[1;31mUnable to find image AMIID\e[0m"
    else
    echo -e "\e[1;32mAMI_ID = ${AMI_ID}\e[0m"
    exit
fi

PRIVATE_IP=$(aws ec2 describe-instances --filters Name=instance-type,Values=${INSTANCE_NAME} --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)

if [ -z "${PRIVATE_IP}" ]; then
aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --output text --tag-specifications "ResourceType=instance,Tags=[{Key=name,Value=${INSTANCE_NAME}}]"
else
    echo "Instance ${INSTANCE_NAME} is already exists, Hence Not Creating"
    exit
fi

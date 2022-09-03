#!/bin/bash

INSTANCE_NAME=$1
if [ -z "${INSTANCE_NAME}" ]; then
    echo -e "\e[1;33mInstance Name Argument is needed\e[0m"
    exit
fi    

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" --query 'Images[*].[ImageId]' --output text)

if [ -z "${AMI_ID}" ]; then
    echo -e "\e[1;31mUnable to find image AMI_ID\e[0m"
    exit
    else
    echo -e "\e[1;32mAMI_ID = ${AMI_ID}\e[0m"
fi

PRIVATE_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${INSTANCE_NAME}" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)

if [ -z "${PRIVATE_IP}" ]; then

SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=allow-all-ports --query "SecurityGroups[*].GroupId" --output text)
if [ -z "${SG_ID}" ]; then
echo -e "\e[1;34mSecurity Group DevOps-Allow-All Does Not Exists"
exit
fi

aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --output text --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${INSTANCE_NAME}}]" \
--instance-market-options "MarketType=spot,SpotOptions={InstanceInterruptionBehavior=stop,SpotInstanceType=persistent}" --security-group-ids "${SG_ID}"
else
echo "Instance ${INSTANCE_NAME} is already exists, Hence Not Creating"
exit
fi



#!/bin/bash

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" --query 'Images[*].[ImageId]' --output text)
if [ -z "${AMI_ID}" ]; then
    echo "Unable to find image AMIID"
    else
    echo AMI_ID = ${AMI_ID}
fi
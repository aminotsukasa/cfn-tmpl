#!/bin/bash

# Lab1のCLIの手順を貼り付けただけ

# リージョンを設定する
AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
export AWS_DEFAULT_REGION=${AZ::-1}

# 最新の Linux AMI を取得する
AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)

echo $AMI

# サブネットを設定
SUBNET=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=LabPublicSubnet' --query Subnets[].SubnetId --output text)

echo $SUBNET

# セキュリティグループを設定
SG=$(aws ec2 describe-security-groups --filters Name=tag:Name,Values=LabInstanceSecurityGroup --query SecurityGroups[].GroupId --output text)

    echo $SG

# ユーザデータを取得
wget https://us-west-2-tcprod.s3.amazonaws.com/courses/ILT-TF-200-ARCHIT/v7.1.8/lab-1-EC2/scripts/UserDataInstanceB.txt

# インスタンスを起動
INSTANCE=$(\
        aws ec2 run-instances \
        --image-id $AMI \
        --subnet-id $SUBNET \
        --security-group-ids $SG \
        --user-data file://./UserDataInstanceB.txt \
        --instance-type t2.micro \
        --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=InstanceB}]' \
        --query 'Instances[*].InstanceId' \
        --output text \
        )




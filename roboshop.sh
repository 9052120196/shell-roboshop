#!/bin/bash

SG_GRP="sg-009fddc01c95aa337"
ami_id="ami-0220d79f3f480ecf5"

for instance in $@
do
instance_id=$(aws ec2 run-instances --image-id $ami_id --security-group-ids $SG_GRP  --instance-type t3.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query Instances[*]  --output table)
if [ $instace_id == "frontend" ]; then
IP=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[*].Instances[*].PublicIpAddress' --output text
)
else
IP=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text
)

fi
done 
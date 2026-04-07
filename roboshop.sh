#!/bin/bash

SG_GRP="sg-009fddc01c95aa337"
ami_id="ami-0220d79f3f480ecf5"

for instance in $@
do
aws ec2 run-instances --image-id $ami_id --security-group-ids $sg-009fddc01c95aa337  --instance-type t3.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[*].{PrivateIP:PrivateIpAddress,Tags:Tags}' --output table

done 
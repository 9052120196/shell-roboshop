#!/bin/bash

SG_GRP="sg-009fddc01c95aa337"
ami_id="ami-0220d79f3f480ecf5"
ZONE="Z040623534ACOY8GUDCDR"
DOMIANNAME="bhaskardevops.online"

for instance in $@
do
instance_id=$(aws ec2 run-instances \
 --image-id $ami_id \
 --security-group-ids $SG_GRP  \
 --instance-type "t3.micro" \
 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
 --query Instances[0].InstanceId  \
 --output text)
if [ $instance_id == "frontend" ]; then
IP=$(aws ec2 describe-instances   --instance-ids $instance_id --query 'Reservations[].Instances[].PublicIpAddress' --output text
)
RECORDNAME=$instance_id.$DOMIANNAME
else
IP=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[].Instances[].PrivateIpAddress' --output text
)
RECORDNAME=$instance_id.$DOMIANNAME

fi

echo "IP address: $IP"

aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE \
    --change-batch '{
  "Comment": "Updating record",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'$RECORDNAME'",
        "Type": "A",
        "TTL": 01,
        "ResourceRecords": [
          {
            "Value": "'$IP'"
          }
        ]
      }
    }
  ]
}
'

echo "Record updated for $instance"
done 
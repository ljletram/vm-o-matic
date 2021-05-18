#!/bin/bash

# get config vars
. config.sh

NEWIP=$(aws ec2 describe-instances --instance-ids $VM_ID --query "Reservations[*].Instances[*].PublicIpAddress" --output=text)
ZONE=$ZONE_ID

cat > route53.json <<- EndOf
{
    "Comment": "Update record to reflect new IP address of VM",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "${VM_ALIAS}.",
                "Type": "A",
                "TTL": 60,
                "ResourceRecords": [
                    {
                        "Value": "${NEWIP}"
                    }
                ]
            }
        }
    ]
}
EndOf

aws route53 change-resource-record-sets --hosted-zone-id $ZONE --change-batch file://./route53.json

rm route53.json





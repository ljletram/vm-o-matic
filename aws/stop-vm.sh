#!/bin/bash

# load config vars
. config.sh
aws ec2 stop-instances --instance-ids $VM_ID



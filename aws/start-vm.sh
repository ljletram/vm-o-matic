#!/bin/bash

# load config values
. config.sh

aws ec2 start-instances --instance-ids $VM_ID



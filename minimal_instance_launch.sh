#!/bin/bash
#
# The code does not automatically terminate your instances! 
# You will have to edit the key name to connect to your instances.
#
aws ec2 run-instances \
    --image-id ami-cad657aa \
    --key-name janet_matsen \
    --instance-type t2.micro \
    --security-group-ids sg-3fbd1e5a sg-ed95fd95 \

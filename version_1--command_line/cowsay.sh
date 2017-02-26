#!/bin/bash
#
# The code does not automatically terminate your instances! 
# You will have to edit the key name to connect to your instances.
# You will have to update the script with your EFS mount information, which I indicated in “<…>” fields
# The script uses the AWS command line interface (CLI) with AWS access keys (I think you already have this setup)
#
# Arguments
#   --image-id
#       The AMI ID of the image you want to run. I used the default
#       Amazon linux AMI.
#
#   --key=name
#       The key pair you will use to access your image.
#
#   --instance-type
#       The EC2 instance type.
#
#   --security-groups
#       The security groups to launch with the instance. This will
#       allow you to SSH to the instance. You may have this set by
#       default and can omit this.
#
#   --iam-instance-profile
#       I'm using this to copy my files to S3 since I do not have
#       an EFS share configured. You can omit this and instead specify
#       a cp command to your EFS share mount point.
#
#   --user-data
#       This is the script that will be ran on instance launch.
#                     
#
for jobId in {1..2}; do
    aws ec2 run-instances \
        --image-id ami-cad657aa \
        --key-name janet_matsen \
        --instance-type t2.micro \
        --security-group-ids sg-3fbd1e5a sg-ed95fd95 \
        --user-data $(cat << EOF | base64 -w 0
#!/bin/bash
cowsay "My jobId was Dunno!" > /home/ec2-user/cowsay_dunno.txt
cowsay "My jobId was ${jobId} and my instance-id is \$(curl http://169.254.169.254/latest/meta-data/instance-id)." > /home/ec2-user/efs/cowsay_${jobId}_instance.txt
EOF
)
done

# Lessons:
# commands are executed as sudo.  Don't use ~ in paths.
# -w 0 is essential for the base64 call. 


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
for jobId in {1..3}; do
    aws ec2 run-instances \
        --image-id ami-f173cc91 \
        --key-name DefaultKeyPair \
        --instance-type t2.micro \
        --security-groups SSH \
        --user-data $(cat << EOF | base64
#!/bin/bash
yum -y install cowsay
mkdir /efs_mount
mount <your EFS IP address>:/<path>/ /efs_mount
cowsay "My jobId was $jobId and my instance-id is \$(curl http://169.254.169.254/latest/meta-data/instance-id)." > /tmp/cow-$jobId.log
cp /tmp/cow-$jobId.log /efs_mount/
EOF
)
done


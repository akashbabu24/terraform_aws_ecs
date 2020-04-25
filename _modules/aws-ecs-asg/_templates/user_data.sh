#!/usr/bin/env bash
# Inject the CloudWatch Logs configuration file contents

sudo yum update -y
sudo yum install -y ecs-init
sudo service docker start
sudo start ecs
mkdir -p /etc/awslogs
#cat > /etc/awslogs/awslogs.conf <<- EOF
#[general]
#state_file = /var/lib/awslogs/agent-state
#[/var/log/dmesg]
#file = /var/log/dmesg
#log_group_name = /var/log/dmesg
#log_stream_name = {cluster}/{container_instance_id}
#[/var/log/messages]
#file = /var/log/messages
#log_group_name = /var/log/messages
#log_stream_name = {cluster}/{container_instance_id}
#datetime_format = %b %d %H:%M:%S
#[/var/log/ecs/ecs-init.log]
#file = /var/log/ecs/ecs-init.log
#log_group_name = /var/log/ecs/ecs-init.log
#log_stream_name = {cluster}/{container_instance_id}
#datetime_format = %Y-%m-%dT%H:%M:%SZ
#[/var/log/ecs/ecs-agent.log]
#file = /var/log/ecs/ecs-agent.log.*
#log_group_name = /var/log/ecs/ecs-agent.log
#log_stream_name = {cluster}/{container_instance_id}
#datetime_format = %Y-%m-%dT%H:%M:%SZ
#[/var/log/ecs/audit.log]
#file = /var/log/ecs/audit.log.*
#log_group_name = /var/log/ecs/audit.log
#log_stream_name = {cluster}/{container_instance_id}
#datetime_format = %Y-%m-%dT%H:%M:%SZ
#EOF

# Create directories for ECS agent
#mkdir -p /var/log/ecs /var/lib/ecs/data /etc/ecs

# TODO: allow custom ECS config to be passed in?
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"

# Install awslogs and the jq JSON parser
#yum update -y
#yum install -y \
#  awslogs \
#  jq \
#  https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
#systemctl enable amazon-ssm-agent
#systemctl start amazon-ssm-agent
#!/bin/sh
#chmod +x /usr/local/bin/bootstrap-awslogs.sh
#systemctl daemon-reload
# systemctl enable bootstrap-awslogs.service
#systemctl enable awslogsd
#systemctl start awslogsd --no-block
# TODO: since we are ECS-optimized, we shouldn't have to do this
# systemctl enable --now --no-block ecs.service
# --==BOUNDARY==
# Content-Type: text/x-shellscript; charset="us-ascii"
# #!/bin/sh
# #Get ECS instance info (we already kinda did this above, but lets grab it again for the custom_userdata)
# until $(curl --output /dev/null --silent --head --fail http://localhost:51678/v1/metadata); do
#     printf '.'
#     sleep 5
# done
# instance_arn=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $NF}')
# az=$(curl -s http://instance-data/latest/meta-data/placement/availability-zone)
# region=$${az:0:$${#az} - 1}
# #Custom userdata script code
# ${custom_userdata}
# # Reclaim unused Docker disk space
# cat <<"EOF" >/usr/local/bin/claimspace.sh
# #!/bin/bash
# # Run fstrim on the host OS periodically to reclaim the unused container data blocks
# docker ps -q | xargs docker inspect --format='{{ .State.Pid }}' | xargs -IZ sudo fstrim /proc/Z/root/
# exit $?
# EOF
# chmod +x /usr/local/bin/claimspace.sh
# echo "0 0 * * * root /usr/local/bin/claimspace.sh" >/etc/cron.d/claimspace
# echo "Done"'

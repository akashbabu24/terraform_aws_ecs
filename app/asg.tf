 # EC2 AutoScaleGroup
module "ASG" {

  source = "../_modules/aws-ecs-asg"
  ami                         = local.ecs_aws_ami
  availability_zones          = local.availability_zones
  environment                 = var.environment
  cluster_name                = aws_ecs_cluster.default.name
  instance_type               = local.instance_type
  #iam_instance_profile_name   = aws_iam_instance_profile.ec2_instance_role.name
  iam_instance_profile_name   =	aws_iam_instance_profile.ecs-iam_profile.name
  max_size                    = local.max_size
  min_size                    = local.min_size
  desired_capacity            = local.desired_capacity
  cloudwatch_prefix           = local.cloudwatch_prefix
  associate_public_ip_address = true
  //new_relic_license           = var.new_relic_license
  //vpc_id                      = module.network.vpc.id
  subnet_ids                  = module.network.private_subnet_ids
  key_name                    = local.instance_ssh_key_name
  security_group_ids		  = [module.ecs-app.security_group]
  //tags                        = module.aws_tags.tags
  # edge_delta_config           = local.edge_delta_config
  # custom_userdata         = "${var.custom_userdata}"
}
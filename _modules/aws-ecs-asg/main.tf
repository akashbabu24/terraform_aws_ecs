data "template_file" "user_data" {
  template = file("${path.module}/_templates/user_data.sh")

  vars = {
    # ecs_config        = var.ecs_config
    ecs_logging       = var.ecs_logging
    cluster_name      = var.cluster_name
	cluster			  = var.cluster_name
    environment       = var.environment
    custom_userdata   = var.custom_userdata
    cloudwatch_prefix = var.cloudwatch_prefix
  }
}

resource "aws_launch_configuration" "ecs-new" {
  name_prefix   = var.cluster_name
  image_id      = var.ami
  instance_type = var.instance_type
  
  //security_groups = compact(
  //  concat(var.security_group_ids, [aws_security_group.instance.id]),
  //)
  
  security_groups = var.security_group_ids
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile        = var.iam_instance_profile_name
  key_name                    = var.key_name
  enable_monitoring           = var.detailed_monitoring
  associate_public_ip_address = var.associate_public_ip_address

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created 
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-cluster-asg2" {
  
  availability_zones        = var.availability_zones
  vpc_zone_identifier       = var.subnet_ids
  name                      = "${var.cluster_name}-asg2"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.ecs-new.name
  health_check_grace_period = var.health_check_grace_period
  enabled_metrics           = var.enabled_metrics

  tag {
    key                 = "Cluster"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  #dynamic "tag" {
   # for_each = var.tags

   # content {
    #  key                 = tag.key
     # value               = tag.value
      #propagate_at_launch = true
    #}
  #}
}
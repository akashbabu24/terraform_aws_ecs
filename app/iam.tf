data "aws_iam_policy_document" "ecs_policies" {
  statement {
            sid = ""
            effect = "Allow"
            actions = [
                "ssmmessages:OpenDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:CreateControlChannel",
                "ssm:UpdateInstanceInformation",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateAssociationStatus",
                "ssm:PutInventory",
                "ssm:PutConfigurePackageResult",
                "ssm:PutComplianceItems",
                "ssm:ListInstanceAssociations",
                "ssm:ListAssociations",
                "ssm:GetParameters",
                "ssm:GetManifest",
                "ssm:GetDocument",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:DescribeAssociation",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "ecs:*",
                "ecr:*",
                "ec2messages:SendReply",
                "ec2messages:GetMessages",
                "ec2messages:GetEndpoint",
                "ec2messages:FailMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:AcknowledgeMessage",
                "ec2:DescribeInstanceStatus",
                "ec2:*",
                "ds:DescribeDirectories",
                "ds:CreateComputer",
                "cloudwatch:PutMetricData"
            ]
            resources = ["*"]
        }
        statement {
            sid = "ECSTaskManagement"
            effect =  "Allow"
            actions = [
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:Describe*",
                "ec2:DetachNetworkInterface",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets",
                "route53:ChangeResourceRecordSets",
                "route53:CreateHealthCheck",
                "route53:DeleteHealthCheck",
                "route53:Get*",
                "route53:List*",
                "route53:UpdateHealthCheck",
                "servicediscovery:DeregisterInstance",
                "servicediscovery:Get*",
                "servicediscovery:List*",
                "servicediscovery:RegisterInstance",
                "servicediscovery:UpdateInstanceCustomHealthStatus"
            ]
            resources = ["*"]
        }
        statement {
            sid = "AutoScaling"
            effect = "Allow"
            actions = [
                "autoscaling:*",
				"autoscaling:Describe*"
            ]
            resources = ["*"]
        }
        statement {
            sid = "AutoScalingManagement"
            effect = "Allow"
            actions = [
                "autoscaling:DeletePolicy",
                "autoscaling:PutScalingPolicy",
                "autoscaling:SetInstanceProtection",
                "autoscaling:UpdateAutoScalingGroup"
            ]
            resources = ["*"]
        }
        statement {
            sid = "AutoScalingPlanManagement"
            effect = "Allow"
            actions = [
                "autoscaling-plans:CreateScalingPlan",
                "autoscaling-plans:DeleteScalingPlan",
                "autoscaling-plans:DescribeScalingPlans"
            ]
            resources = ["*"]
        }
        statement {
            sid = "CWAlarmManagement"
            effect = "Allow"
            actions = [
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:PutMetricAlarm"
            ]
            resources = ["arn:aws:cloudwatch:*:*:alarm:*"]
        }
        statement {
            sid = "ECSTagging"
            effect = "Allow"
            actions = [
                "ec2:CreateTags"
            ]
            resources = ["arn:aws:ec2:*:*:network-interface/*"]
        }
        statement {
            sid = "CWLogGroupManagement"
            effect = "Allow"
            actions = [
                "logs:CreateLogGroup",
                "logs:DescribeLogGroups",
                "logs:PutRetentionPolicy"
            ]
            resources = ["arn:aws:logs:*:*:log-group:/aws/ecs/*"]
        }
        statement {
            sid = "CWLogStreamManagement"
            effect = "Allow"
            actions = [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ]
            resources =  ["arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"]
        }
}

resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role2"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
}

resource "aws_iam_role_policy" "all_policies" {
  name   = local.fullNameEnv
  policy = data.aws_iam_policy_document.ecs_policies.json
  role   = aws_iam_role.ecs-instance-role.id
}

data "aws_iam_policy_document" "ecs-instance-policy" {
   statement {
  actions = ["sts:AssumeRole"]
  principals {
  type = "Service"
  identifiers = ["ec2.amazonaws.com"]
  }
 }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
   role = "${aws_iam_role.ecs-instance-role.name}"
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-iam_profile" {
  name = "ecs-iam-profile7"
  path = "/"
  role = "${aws_iam_role.ecs-instance-role.id}"
  provisioner "local-exec" {
  command = "sleep 60"
 }
}

resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role2"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment1" {
  role = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-attachment" {
  role = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment2" {
  role = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
  actions = ["sts:AssumeRole"]
  principals {
  type = "Service"
  identifiers = [
          "ecs-tasks.amazonaws.com",
          "ec2.amazonaws.com",
          "ecs.amazonaws.com"
        ]
  }
 }
}

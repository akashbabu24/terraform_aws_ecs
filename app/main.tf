terraform {
  backend "s3" {
    bucket         = ""
    dynamodb_table = ""
    key            = ""
    region         = ""
  }
}

provider "aws" {
  region  = var.region
  version = "~> 2.8"
}

module "network" {
  source = "../_modules/vpc"
}

resource "aws_ecs_cluster" "default" {
  name = local.fullNameEnv
  #tags = module.aws_tags.tags
}

locals {
  load_balancers = [
	{
      container_name   = local.container1_name
      container_port   = local.container1_container_port
      elb_name         = module.alb.alb_name
      target_group_arn = module.alb.target_group_arn
    }
  ]
}
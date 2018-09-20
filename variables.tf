# main creds for AWS connection

variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "ecs_key_pair_name" {
  description = "ECS key pair name"
}

variable "region" {
  description = "AWS region"
}

variable "availability_zone" {
  description = "availability zone used for the demo, based on region"
  default = {
    eu-west-1 = "eu-west-1"
  }
}

########################### Test VPC Config ################################

variable "test_vpc" {
  description = "VPC for Test environment"
}

variable "test_network_cidr" {
  description = "IP addressing for Test Network"
}

variable "test_public_01_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

variable "test_public_02_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

########################### Autoscale Config ################################

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}

variable "desired_capacity_fargate" {
  description = "Desired number of tasks in fargate cluster"
}

variable "desired_capacity_ecsec2" {
  description = "Desired number of tasks in ec2 service cluster"
}

###########DNS hosted zone for tietoaws.com ###########
variable "tietoaws_com_zone_id" {
  description = "DNS hosted zone for tietoaws.com"
}

variable "ecs_log_level" {
  description = "Log level for the ECS agent."
  default     = "info"
}
variable "ecs_autoscaling_group_name" {
  
}
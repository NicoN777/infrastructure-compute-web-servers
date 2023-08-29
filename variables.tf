variable "instance_name" {
  description = "The EC2 Instance Name"
  type = string
  default = "web-server"
}

variable "free_tier_instance" {
  description = "The EC2 Instance Type"
  type = string
  default = "t2.micro"
}

variable "ami_amazon_linux" {
  description = "The ID for the EC2 Amazon Image"
  type = string
  default = "090e0fc566929d98b"
}

variable "number_of_instances" {
  description = "The number of EC2 Instances to deploy"
  type = number
  default = 1
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "just-boxey-things"
    workspaces = {
      name = "aws-network"
    }
  }
}

data "aws_vpc" "vpc" {
  id = data.terraform_remote_state.vpc.outputs.main.id
}


data "aws_subnets" "public_subnets" {
      filter {
        name   = "vpc-id"
        values = [data.aws_vpc.vpc.id]
      }

      tags = {
        Name = "*public*"
      }
  
}

data "aws_security_groups" "web_server_security_groups" {
  
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name = "group-name"
    values = [ "ssh-sg", "web-servers-sg*" ]
  }
  
}

data "aws_subnet" "public_subnet" {
  for_each = toset(data.aws_subnets.public_subnets.ids)
  id = each.value
}


output "public_subnets_cidr_blocks" {
  value = [for s in data.aws_subnet.public_subnet : s.cidr_block]
}


data "aws_key_pair" "web_servers_key" {
  key_name = "web-servers"
}

locals {
  ami = "ami-${var.ami_amazon_linux}"
  number_of_instances = var.number_of_instances
  name_prefix = var.instance_name
}

variable "ec2_tags" {
  type = map(string)
  default = {
    Terraform = "true",
    Team = "pika"
    Tier = "web"
  }
}



provider "aws" {
  region = "us-east-1"
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  count = local.number_of_instances
  name  = "${local.name_prefix}-${count.index}"

  ami                    = local.ami
  instance_type          = var.free_tier_instance
  subnet_id              = data.aws_subnets.public_subnets.ids[count.index]
  vpc_security_group_ids = data.aws_security_groups.web_server_security_groups.ids
  key_name = data.aws_key_pair.web_servers_key.key_name
  associate_public_ip_address = true

  tags = var.ec2_tags
}
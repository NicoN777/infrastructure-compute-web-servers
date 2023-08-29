output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = module.ec2_instances[*].public_ip
}

output "web_servers_key_pair_out" {
  description = "Key Pair for Web Servers"
  value = data.aws_key_pair.web_servers_key
}
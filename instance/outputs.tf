output "instance_ids" {
  value = try(aws_instance.instance.*.id, "")
}

output "instance_azs" {
  value = aws_instance.instance.*.availability_zone
}

output "instance_key_names" {
  value = aws_instance.instance.*.key_name
}

output "instance_public_dns" {
  value = aws_instance.instance.*.public_dns
}

output "instance_public_ips" {
  value = aws_instance.instance.*.public_ip
}

output "instance_network_interface_ids" {
  value = aws_instance.instance.*.primary_network_interface_id
}

output "instance_private_dns" {
  value = aws_instance.instance.*.private_dns
}

output "instance_private_ip" {
  value = aws_instance.instance.*.private_ip
}

output "instance_vpc_security_group_ids" {
  value = aws_instance.instance.*.vpc_security_group_ids
}

output "instance_subnet_ids" {
  value = aws_instance.instance.*.subnet_id
}

output "role_id" {
  value = try(aws_iam_role.role[0].id,var.instance_profile)
}

output "role_name" {
  value = try(aws_iam_role.role[0].name,"")
}

output "policy_name" {
  value = try(aws_iam_policy.policy[0].name,"")
}
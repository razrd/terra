output "sg_id" {
  description = "ID of the Neo4j security group"
  value       = "${aws_security_group.sg.id}"
}

output "instance_ids" {
  description = "List: IDs of the EC2 instances"
  value       = "${module.neo4j.instance_ids}"
}

output "instances_role_id" {
  description = "IAM role ID used by the EC2 instances"
  value       = "${module.neo4j.role_id}"
}

output "instance_public_dns" {
  description = "List: The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = "${module.neo4j.instance_public_dns}"
}

output "instance_public_ips" {
  description = "List: The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use public_ip, as this field will change after the EIP is attached."
  value       = "${module.neo4j.instance_public_ips}"
}

output "instance_private_dns" {
  description = "List: The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = "${module.neo4j.instance_private_dns}"
}

output "instance_private_ips" {
  description = "List: The private IP address assigned to the instances"
  value       = "${module.neo4j.instance_private_ip}"
}

output "route53_fqdns" {
  description = "List: Route 53 fqdns applied"
  value       = aws_route53_record.dns_record.*.fqdn
}

output "loadbalancer_arn" {
  description = "((): Arn of the loadbalancer provisioned)"
  value       = aws_lb.nlb.*.arn
}

output "loadbalancer_name" {
  description = "((): Friendly name of the loadbalancer provisioned)"
  value       = aws_lb.nlb.*.name
}

output "https_listener_arn" {
  description = "((): https listener arn of the loadbalancer)"
  value       = aws_lb_listener.https_listener.*.arn
}

output "bolt_listener_arn" {
  description = "((): https listener arn of the loadbalancer)"
  value       = aws_lb_listener.bolt_listener.*.arn
}

output "https_target_group_arn" {
  description = "((): https target group arn of the loadbalancer)"
  value       = aws_lb_target_group.https_target.*.arn
}

output "bolt_target_group_arn" {
  description = "((): bolt target group arn of the loadbalancer)"
  value       = aws_lb_target_group.bolt_target.*.arn
}

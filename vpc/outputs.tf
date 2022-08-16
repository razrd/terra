output vpc_id {
  value       = try(aws_vpc.vpc[0].id, "")
  description = "vpc id"
}

output arn {
  value       = try(aws_vpc.vpc[0].arn, "")
}

output default_route_table_id {
  value       = try(aws_vpc.vpc[0].default_route_table_id, "")
}

output default_security_group_id {
  value       = try(aws_vpc.vpc[0].default_security_group_id, "")
}
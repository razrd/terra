output "zone_id" {
  value = data.aws_route53_zone.domain.*.zone_id
}

output "domain_arn" {
  value = data.aws_route53_zone.domain.*.arn
}

output "name_servers" {
  value = data.aws_route53_zone.domain.*.name_servers
}

output "record_fqdn" {
  value = aws_route53_record.dns_record.*.fqdn
}

output "record_name" {
  value = aws_route53_record.dns_record.*.name
}

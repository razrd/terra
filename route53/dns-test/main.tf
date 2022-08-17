data "aws_route53_zone" "domain" {
  count = var.r53_domain == "" ? 0 : 1
  name  = var.r53_domain
}


resource "aws_route53_record" "dns_record" {
  count   = var.r53_domain == "" ? 0 : 1
  zone_id = data.aws_route53_zone.domain[0].zone_id
  name    = "dnstestrecord-${format("%02d", count.index + 1)}.${data.aws_route53_zone.domain[0].name}"
  type    = "A"
  ttl     = "60"
  records = var.ip_addr_record
}

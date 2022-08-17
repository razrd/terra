data "aws_route53_zone" "domain" {
  count = var.r53_domain == "" ? 0 : 1
  name  = var.r53_domain
}

resource "aws_route53_record" "dns_record" {
  count   = var.r53_domain_id == "" ? 0 : var.neo4j_instance_count
  zone_id = data.aws_route53_zone.domain[0].zone_id
  name    = "${var.project}-${var.name}-${var.neo4j_key}-${format("%02d", count.index + 1)}.${data.aws_route53_zone.domain[0].name}"
  type    = "A"
  ttl     = "60"
  records = ["${module.neo4j.instance_private_ip[count.index]}"]
}
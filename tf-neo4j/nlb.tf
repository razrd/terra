/*
Refer: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateTargetGroup.html
Leaving out NLB health checks to defaults for now.
*/
resource "aws_lb_target_group" "https_target" {
  count = var.nlb_enabled ? 1 : 0
  name        = join("-", [var.project,"https-target"])

  vpc_id      = var.vpc_id
  port        = 7473
  protocol    = "TCP"
  tags = merge(
    var.tags,
    {
        "Environment" = var.environment
        "Project"     = var.project
    })
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "bolt_target" {
  count = var.nlb_enabled ? 1 : 0
  name        = join("-", [var.project,"bolt-target"])

  vpc_id      = var.vpc_id
  port        = 7687
  protocol    = "TCP"
  
  tags = merge(
    var.tags,
    {
        "Environment" = var.environment
        "Project"     = var.project
    })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "nlb" {
  count = var.nlb_enabled ? 1 : 0
  name = join("-", [var.project, "nlb-neo4j"])
  
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  subnets            = var.subnet_ids

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  ip_address_type                  = var.ip_address_type

  tags = merge(
    var.tags,
    {
        "Environment" = var.environment
        "Project"     = var.project
    })

  depends_on = [
    aws_lb_target_group.https_target,
    aws_lb_target_group.bolt_target
  ]
}


resource "aws_lb_listener" "https_listener" {
  count = var.nlb_enabled ? 1 : 0
  load_balancer_arn = aws_lb.nlb[count.index].arn
  port              = 7473
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.https_target[count.index].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "bolt_listener" {
  count = var.nlb_enabled ? 1 : 0
  load_balancer_arn = aws_lb.nlb[count.index].arn
  port              = 7687
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.bolt_target[count.index].arn
    type             = "forward"
  }
}


resource "aws_lb_target_group_attachment" "https_attach" {
  #for_each = toset(module.neo4j.instance_ids)
  #count = length(module.neo4j.instance_ids) ? 1 : 0
  count = var.nlb_enabled ? 1 : 0
  target_group_arn = aws_lb_target_group.https_target[0].arn
  target_id        = module.neo4j.instance_ids[count.index]
  #target_id       = each.value
  port             = 7473

  depends_on = [
    aws_lb.nlb
  ]
}

resource "aws_lb_target_group_attachment" "bolt_attach" {
  #for_each = toset(module.neo4j.instance_ids)
  #count = length(module.neo4j.instance_ids) ? 1 : 0
  count = var.nlb_enabled ? 1 : 0
  target_group_arn = aws_lb_target_group.bolt_target[0].arn
  target_id        = module.neo4j.instance_ids[count.index]
  #target_id       = each.value
  port             = 7687

  depends_on = [
    aws_lb.nlb
  ]
}



/* 
// Dynamic blocks for accepting map/set type of inputs. Tested and placed for reference but not used.

resource "aws_lb_target_group" "main" {
  count = var.nlb_enabled ? length(var.target_groups) : 0
  name        = join("-", [var.project,"target-group"])

  vpc_id           = var.vpc_id
  port             = lookup(var.target_groups[count.index], "backend_port", null)
  protocol         = lookup(var.target_groups[count.index], "backend_protocol", null) != null ? upper(lookup(var.target_groups[count.index], "backend_protocol")) : null
  protocol_version = lookup(var.target_groups[count.index], "protocol_version", null) != null ? upper(lookup(var.target_groups[count.index], "protocol_version")) : null
  target_type      = lookup(var.target_groups[count.index], "target_type", null)

  deregistration_delay               = lookup(var.target_groups[count.index], "deregistration_delay", null)
  slow_start                         = lookup(var.target_groups[count.index], "slow_start", null)
  proxy_protocol_v2                  = lookup(var.target_groups[count.index], "proxy_protocol_v2", false)
  #lambda_multi_value_headers_enabled = lookup(var.target_groups[count.index], "lambda_multi_value_headers_enabled", false)
  preserve_client_ip                 = lookup(var.target_groups[count.index], "preserve_client_ip", null)

  dynamic "health_check" {
    for_each = length(keys(lookup(var.target_groups[count.index], "health_check", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "health_check", {})]

    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
    }
  }

  dynamic "stickiness" {
    for_each = length(keys(lookup(var.target_groups[count.index], "stickiness", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "stickiness", {})]

    content {
      enabled         = lookup(stickiness.value, "enabled", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      type            = lookup(stickiness.value, "type", null)
      cookie_name     = lookup(stickiness.value, "cookie_name", null)
    }
  }
  tags = var.tags


  lifecycle {
    create_before_destroy = true
  }
}
*/
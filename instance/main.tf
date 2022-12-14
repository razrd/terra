module "is_ebs_optimised" {
  source        = "../is_ebs_optimised"
  instance_type = var.instance_type
}

module "get_policy_arn" {
  source        = "../get_policy_arn"
  boundary_policy_name = var.role_permissions_boundary
}

resource "aws_instance" "instance" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = var.create_instance_profile ? aws_iam_instance_profile.profile[0].id : var.instance_profile
  vpc_security_group_ids      = var.sgs
  subnet_id                   = element(var.subnets, count.index)
  disable_api_termination     = var.termination_protection
  ebs_optimized               = module.is_ebs_optimised.is_ebs_optimised
  associate_public_ip_address = var.public_ip

  user_data                   = fileexists(var.user_data[0]) ? file(var.user_data[0]) : var.user_data[0]

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint 
    http_put_response_hop_limit = var.metadata_hop_limit 
    instance_metadata_tags      = var.metadata_instance_tags
  }

  root_block_device {
    volume_type           = var.root_vl_type
    volume_size           = var.root_vl_size
    delete_on_termination = var.root_vl_delete
    encrypted             = var.root_vl_encrypt
    kms_key_id            = var.root_vl_kms_key_id
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {

      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  tags = merge(
    var.tags,
    {
      "Name"        = "${var.project}-${var.environment}-${var.name}${count.index + 1}"
      "Function"    = var.name
      "Environment" = var.environment
      "Project"     = var.project
    },
  )

  lifecycle {
    ignore_changes = [
      key_name,
      user_data,
      root_block_device
    ]
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }
}
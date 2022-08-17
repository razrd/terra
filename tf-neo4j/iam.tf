data "aws_iam_policy_document" "instances" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeVolume*",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeSnapshots"
    ]
  }
}

resource "aws_iam_policy" "instances" {
  name   = "CustomerManaged_${var.project}_${var.environment}_${var.name}_ec2-desc"
  policy = data.aws_iam_policy_document.instances.json
}

resource "aws_iam_role_policy_attachment" "instances_core" {
  role       = try(module.neo4j.role_id,"")
  policy_arn = aws_iam_policy.instances.arn
}

data "aws_iam_policy_document" "cwlogs" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
  }
}

resource "aws_iam_policy" "cwlogs" {
  count  = var.cloudwatch_logs_enabled ? 1 : 0
  name   = "CustomerManaged_${var.project}_${var.environment}_${var.name}_cwlog-write"
  policy = data.aws_iam_policy_document.cwlogs.json
}

resource "aws_iam_role_policy_attachment" "cwlogs_core" {
  count      = var.cloudwatch_logs_enabled ? 1 : 0
  role       = module.neo4j.role_id
  policy_arn = aws_iam_policy.cwlogs[0].arn
}
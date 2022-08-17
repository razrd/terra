resource "aws_iam_instance_profile" "profile" {
  count = (var.create_instance_profile && var.instance_count != 0) ? 1 : 0
  name  = "CustomerManaged_${var.project}_${var.environment}_${var.name}"
  role  = aws_iam_role.role[0].name
}

resource "aws_iam_role" "role" {
  count = (var.create_instance_profile && var.instance_count != 0) ? 1 : 0
  name  = "CustomerManaged_${var.project}_${var.environment}_${var.name}"
  permissions_boundary = var.role_permissions_boundary
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "policy" {
  count = (var.create_instance_profile && var.instance_count != 0) ? 1 : 0
  name        = "CustomerManaged_${var.project}_${var.environment}_${var.name}_s3-policy"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
       {
            "Sid": "AllowAccountLevelS3Actions",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAccessPoints",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Sid": "AllowListAndReadS3ActionOnTFBucket",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.iam_s3_bucket_ref}/*",
                "arn:aws:s3:::${var.iam_s3_bucket_ref}"
            ]
        },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "policy_atach_role" {
  count = var.create_instance_profile ? 1 : 0
  role       = try(aws_iam_role.role[0].name,"")
  policy_arn = try(aws_iam_policy.policy[0].arn,"")
}
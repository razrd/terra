resource "aws_iam_instance_profile" "profile" {
  count = var.instance_count == 0 ? 0 : 1
  name  = "profile_${var.name}_${var.project}_${var.environment}"
  role  = aws_iam_role.role[0].name
}

resource "aws_iam_role" "role" {
  count = var.instance_count == 0 ? 0 : 1
  name  = "role_${var.name}_${var.project}_${var.environment}"

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
  count = var.instance_count == 0 ? 0 : 1
  name        = "policy_${var.name}_${var.project}_${var.environment}_s3"
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
                "arn:aws:s3:::lab01s3tf/*",
                "arn:aws:s3:::lab01s3tf"
            ]
        },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "policy_atach_role" {
  role       = aws_iam_role.role[0].name
  policy_arn = aws_iam_policy.policy[0].arn
}
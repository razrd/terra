output "boundary_policy_arn" {
  description = "arn of the provided boundary iam policy"
  value       = data.aws_iam_policy.get.arn
}

output "boundary_policy_id" {
  description = "friendly iam policy id"
  value       = data.aws_iam_policy.get.id
}
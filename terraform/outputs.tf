output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "alb_dns" {
  value = aws_lb.app_lb.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.service.name
}

output "task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}

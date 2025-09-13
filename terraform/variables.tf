variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "devops-cicd"
}

variable "desired_count" {
  description = "Desired count for the ECS service"
  type        = number
  default     = 1
}

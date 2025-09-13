# DevOps CI/CD Pipeline (Flask app → Docker → ECR → ECS Fargate)  

This repository demonstrates a **production-like CI/CD pipeline**:
- Build a Docker image of a Flask app
- Push image to Amazon ECR
- Register new ECS task definition and update ECS Fargate service
- ALB routes traffic to tasks — ECS deployment settings provide rolling updates (zero-downtime)

---

## Repo structure
(see project tree in README header)

---

## Prerequisites

- An **AWS account** with an IAM user that has sufficient permissions (ECR, ECS, ALB, IAM, CloudWatch, EC2, VPC, IAM).
- **Terraform** (v1.0+)
- **AWS CLI** installed and configured with credentials (`aws configure`)
- **Docker** (for building images)
- **Jenkins** (or any CI runner that can run the provided Jenkinsfile). Jenkins agent must have Docker, awscli, and `jq` installed.

### Minimal IAM permissions
Create an IAM user or role with these managed policies (or equivalent granular permissions):
- AmazonEC2ContainerRegistryFullAccess
- AmazonECS_FullAccess
- IAMFullAccess (or scoped policies for roles)
- AmazonVPCFullAccess (or sufficient to create VPC/subnets/IGW/RT)
- ElasticLoadBalancingFullAccess
- CloudWatchLogsFullAccess

> In production, scope down IAM permissions — these are for demo/dev convenience.

---

## Steps

### 1) Provision AWS infrastructure with Terraform
```bash
cd terraform
terraform init
terraform apply -var="region=us-east-1"

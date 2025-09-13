#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <image_uri> <aws_region>"
  exit 1
fi

IMAGE_URI="$1"
AWS_REGION="$2"

# These values must match what's created by Terraform (change if needed)
CLUSTER_NAME="devops-cicd-cluster"
SERVICE_NAME="devops-cicd-service"
TASK_FAMILY="devops-cicd-task"

echo "Registering new task definition with image: ${IMAGE_URI}"

# Load template and replace placeholder
TASK_DEF_JSON=$(sed "s|REPLACE_IMAGE|${IMAGE_URI}|g" terraform/ecs-task-def.tpl.json)

# Register task definition
REGISTERED=$(aws ecs register-task-definition --cli-input-json "${TASK_DEF_JSON}" --region "${AWS_REGION}")
REVISION=$(echo "${REGISTERED}" | jq -r '.taskDefinition.revision')
TASK_DEF_ARN=$(echo "${REGISTERED}" | jq -r '.taskDefinition.taskDefinitionArn')

echo "Registered task definition: ${TASK_DEF_ARN} (revision ${REVISION})"

# Update service to use new task definition
echo "Updating ECS service ${SERVICE_NAME} in cluster ${CLUSTER_NAME}"
aws ecs update-service --cluster "${CLUSTER_NAME}" --service "${SERVICE_NAME}" --task-definition "${TASK_FAMILY}:${REVISION}" --region "${AWS_REGION}"

echo "Service updated. Waiting for stable deployment..."
aws ecs wait services-stable --cluster "${CLUSTER_NAME}" --services "${SERVICE_NAME}" --region "${AWS_REGION}"

echo "Deployment complete."

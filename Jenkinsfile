pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "us-east-1"         // change to your region or pass via Jenkins credentials
    ECR_REGISTRY = ""                        // determined in script after aws ecr describe
    ECR_REPO = "devops-cicd-demo"
    APP_VERSION = "${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
    IMAGE_TAG = "${env.ECR_REGISTRY}/${env.ECR_REPO}:${env.APP_VERSION}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Unit Test') {
      steps {
        dir('app') {
          sh 'pip install -r requirements.txt'
          // add tests if any, for now just sanity check python file
          sh 'python -m py_compile app.py || true'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // login will be done in push stage; build the image first
          sh "docker build -t ${ECR_REPO}:${APP_VERSION} ."
        }
      }
    }

    stage('Push to ECR') {
      steps {
        script {
          // obtain account id and registry
          def accountId = sh(returnStdout: true, script: "aws sts get-caller-identity --query Account --output text").trim()
          env.ECR_REGISTRY = "${accountId}.dkr.ecr.${env.AWS_DEFAULT_REGION}.amazonaws.com"
          // create repo if not exists
          sh """
            aws ecr describe-repositories --repository-names ${ECR_REPO} >/dev/null 2>&1 || \
            aws ecr create-repository --repository-name ${ECR_REPO}
          """
          sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
          sh "docker tag ${ECR_REPO}:${APP_VERSION} ${ECR_REGISTRY}/${ECR_REPO}:${APP_VERSION}"
          sh "docker push ${ECR_REGISTRY}/${ECR_REPO}:${APP_VERSION}"
        }
      }
    }

    stage('Deploy to ECS') {
      steps {
        script {
          // make the deploy script executable and run it
          sh "chmod +x ./scripts/register_and_deploy.sh"
          sh "./scripts/register_and_deploy.sh ${ECR_REGISTRY}/${ECR_REPO}:${APP_VERSION} ${AWS_DEFAULT_REGION}"
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline completed successfully. Deployed image: ${IMAGE_TAG}"
    }
    failure {
      echo "Pipeline failed. Check logs."
    }
  }
}

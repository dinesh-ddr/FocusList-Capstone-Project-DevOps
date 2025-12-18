pipeline {
  agent any

  environment {
    TF_DIR = 'infra'
    APP_NS = 'app'
    DEPLOY_NAME = 'todo-deployment'
    SERVICE_NAME = 'todo-service'
  }

  stages {

    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Tool Versions') {
      steps {
        sh 'aws --version; terraform -version; kubectl version --client; docker --version'
      }
    }

    stage('AWS Identity') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh 'aws sts get-caller-identity --region $AWS_REGION'
        }
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir("$TF_DIR") {
          withCredentials([
            string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
          ]) {
            sh 'terraform init'
            sh 'terraform apply -auto-approve'
            sh 'terraform output'
          }
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            TAG=$(git rev-parse --short HEAD)
            ACCOUNT=$(aws sts get-caller-identity --query Account --output text --region $AWS_REGION)
            REGISTRY=$ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com
            REPO=$REGISTRY/$ECR_REPO

            aws ecr create-repository --repository-name $ECR_REPO --region $AWS_REGION || true
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REGISTRY

            docker build -t $REPO:$TAG .
            docker push $REPO:$TAG

            echo "$REPO:$TAG" > image.txt
          '''
        }
      }
    }

    stage('Deploy to EKS') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

            kubectl apply -f manifests/namespace.yaml
            kubectl apply -f manifests/deployment.yaml
            kubectl apply -f manifests/service.yaml

            HOST=$(kubectl -n $APP_NS get svc $SERVICE_NAME -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
            echo "APP URL: http://$HOST"
          '''
        }
      }
    }

    stage('Rollout Image') {
      steps {
        sh '''
          IMAGE=$(cat image.txt)
          kubectl -n $APP_NS set image deployment/$DEPLOY_NAME app=$IMAGE
          kubectl -n $APP_NS rollout status deployment/$DEPLOY_NAME
        '''
      }
    }

  }

  post {
    always {
      archiveArtifacts artifacts: 'image.txt', allowEmptyArchive: true
    }
  }
}

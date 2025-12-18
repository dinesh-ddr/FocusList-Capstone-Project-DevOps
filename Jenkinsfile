pipeline {
  agent { label 'capstone-agent' }

  environment {
    AWS_REGION       = "ap-south-1"
    TF_IN_AUTOMATION = "true"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/dinesh-ddr/FocusList-Capstone-Project-DevOps.git'
      }
    }

    stage('Tool Sanity Check') {
      steps {
        sh '''
          git --version
          docker --version
          aws --version
          terraform -version
          kubectl version --client
          java -version
        '''
      }
    }

    stage('AWS Identity Verification') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh 'aws sts get-caller-identity --region $AWS_REGION'
        }
      }
    }

    stage('Terraform Init / Plan / Apply') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          dir('infra') {
            sh '''
              echo "Cleaning old Terraform cache"
              rm -rf .terraform .terraform.lock.hcl

              terraform init
              terraform plan -out=tfplan
              terraform apply -auto-approve tfplan

              echo "Terraform Outputs:"
              terraform output
            '''
          }
        }
      }
    }
  }
}

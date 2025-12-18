pipeline {
  agent { label 'capstone-agent' }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Validate') {
      steps {
        sh '''
          test -f index.html || (echo "index.html missing" && exit 1)
          test -f styles.css || (echo "styles.css missing" && exit 1)
          test -f app.js || (echo "app.js missing" && exit 1)
          echo "Validated static files."
        '''
      }
    }

    pipeline {
  agent { label 'capstone-agent' }

  tools {
    git 'linux-git'
  }

  stages {
    stage('Checkout') { steps { checkout scm } }
    ...
  }
}


    stage('Tool Sanity Check') {
      steps {
        sh '''
          docker --version
          aws --version
          terraform -version
          kubectl version --client
          java -version
        '''
      }
    }

    stage('Terraform Backend Check') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            cd infra
            terraform init
          '''
        }
      }
    }

    stage('AWS Identity Verification') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh 'aws sts get-caller-identity --region ap-south-1'
        }
      }
    }

    stage('Terraform Plan & Apply') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            cd infra
            terraform init
            terraform plan -out=tfplan
            terraform apply -auto-approve tfplan
            terraform output
          '''
        }
      }
    }

    stage('Package') {
      steps {
        sh '''
          rm -f focuslist.zip
          zip -r focuslist.zip index.html styles.css app.js
          echo "Created focuslist.zip"
        '''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'focuslist.zip', allowEmptyArchive: false
    }
  }
}

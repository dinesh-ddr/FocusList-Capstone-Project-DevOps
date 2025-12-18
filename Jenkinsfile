pipeline {
  agent any

  parameters {
    string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS region')
    string(name: 'S3_BUCKET', defaultValue: 'YOUR_BUCKET_NAME', description: 'S3 bucket for static hosting')
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Validate') {
      steps {
        powershell '''
          if (!(Test-Path index.html)) { throw "index.html missing" }
          if (!(Test-Path styles.css)) { throw "styles.css missing" }
          if (!(Test-Path app.js)) { throw "app.js missing" }
          Write-Host "Validated static files."
        '''
      }
    }

    stage('Package') {
      steps {
        powershell '''
          Remove-Item -Force focuslist.zip -ErrorAction SilentlyContinue
          Compress-Archive -Path index.html,styles.css,app.js -DestinationPath focuslist.zip -Force
        '''
      }
    }
stage('Check AWS CLI') {
  steps {
    powershell '''
      aws --version
    '''
  }
}

    stage('Deploy to S3') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          powershell '''
            aws --version
            aws s3 sync . s3://$env:S3_BUCKET --exclude "*" --include "index.html" --include "styles.css" --include "app.js" --region $env:AWS_REGION
            Write-Host "Deployed to S3 bucket: $env:S3_BUCKET"
          '''
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'focuslist.zip', allowEmptyArchive: false
    }
  }
}

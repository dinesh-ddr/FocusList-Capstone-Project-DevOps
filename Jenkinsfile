pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Tool Versions') {
      steps {
        powershell '''
          git --version
          docker --version
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        powershell '''
          docker build -t focuslist:latest .
        '''
      }
    }

    stage('Deploy (Run Container)') {
      steps {
        powershell '''
          docker stop focuslist 2>$null
          docker rm focuslist 2>$null
          docker run -d --name focuslist -p 8080:80 focuslist:latest
          Write-Host "App should be available at: http://localhost:8080"
        '''
      }
    }
  }
}

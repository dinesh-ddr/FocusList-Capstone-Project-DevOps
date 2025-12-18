pipeline {
  agent { label 'capstone-agent' }

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


    stage('Package') {
      steps {
        powershell '''
          Remove-Item -Force focuslist.zip -ErrorAction SilentlyContinue
          Compress-Archive -Path index.html,styles.css,app.js -DestinationPath focuslist.zip -Force
          Write-Host "Created focuslist.zip"
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

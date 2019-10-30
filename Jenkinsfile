pipeline {
  agent {
    node {
      label 'master'
    }

  }
  stages {
    stage('Tests') {
      steps {
        sh 'chmod +x run-tests.sh'
        sh './run-tests.sh'
      }
    }
  }
}
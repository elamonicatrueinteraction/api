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

    stage('Deploy Staging') {
      when {
        branch 'staging'
      }
      steps {
        echo 'Staging..'
      }
    }

    stage('Deploy Demo') {
      when {
        branch 'demo'
      }
      steps {
        echo 'Demo..'
      }
    }

    stage('Deploy Producción') {
      when {
        branch 'master'
      }
      steps {
        echo 'Producción..'
      }
    }
  }
}
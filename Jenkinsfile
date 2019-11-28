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
        sshagent(credentials: ['staging-ssh']) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@3.93.159.120 \'/home/ubuntu/.local/bin/gitup .\''
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@3.93.159.120 \'chmod +x ./nilus-infra/scripts/deploy-logistic-api.sh\''
          sh 'ssh -o \'StrictHostKeyChecking=no\' ubuntu@3.93.159.120 \'cd nilus-infra && ./scripts/deploy-logistic-api.sh\''
        }

      }
    }
    stage('Deploy Demo') {
      when {
        branch 'demo'
      }
      steps {
        sshagent(credentials: ['demo-ssh']) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@3.214.27.227 \'/home/ubuntu/.local/bin/gitup .\''
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@3.214.27.227 \'chmod +x ./nilus-infra/scripts/deploy-logistic-api.sh\''
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@3.214.27.227 \'cd nilus-infra && ./scripts/deploy-logistic-api.sh\''
        }
      }
    }
  }
}

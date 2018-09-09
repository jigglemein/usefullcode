pipeline {
  agent any
  stages {
    stage('Packer Validate') {
      steps {
        sh "cd packer;/usr/bin/packer validate webserver.json"
      }
    }
    stage('Packer Build') {
      steps {
        sh "cd packer;/usr/bin/packer build webserver.json"
      }
    }
    stage('Terraform: Init') {
      steps {
        sh "cd terraform; terraform init"
      }
    }
    stage('Terraform: apply') {
      steps {
        sh "cd terraform; terraform apply --auto-approve"
      }
    }

  }
  post {
    always {
      cleanWs()
    }
  }
}

pipeline {
  agent any
  stages {
    stage('Terraform: Init') {
      steps {
        sh "cd terraform; terraform init"
      }
    }
    stage('Terraform: Plan') {
      steps {
        sh "export TF_WORKSPACE=${params.USERNAME}"
        sh "cd terraform; terraform plan -var 'env=${params.USERNAME}'"
      }
    }
    stage('Terraform: apply') {
      steps {
  
        sh "export TF_WORKSPACE=${params.USERNAME}"
        sh "cd terraform; terraform apply -var 'env=${params.USERNAME}' --auto-approve"
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}

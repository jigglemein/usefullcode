pipeline {
  agent any
  stages {
    stage('Terraform: Init') {
      steps {
        sh "export TF_WORKSPACE=${params.USERNAME}"
        sh "cd terraform; terraform init"
      }
    }
    stage('Terraform: Plan and Apply') {
      when {
        expression { params.ACTION == 'APPLY' }
      }
      steps {
        sh "export TF_WORKSPACE=${params.USERNAME}"
        sh "cd terraform; export TF_WORKSPACE=${params.USERNAME}; terraform plan -var 'env=${params.USERNAME}'"
        sh "cd terraform; export TF_WORKSPACE=${params.USERNAME}; terraform apply -var 'env=${params.USERNAME}' --auto-approve"
      }
    }
    stage('Terraform: destroy') {
      when {
        expression { params.ACTION == 'DESTROY' }
      }
      steps {
        sh "export TF_WORKSPACE=${params.USERNAME}"
        sh "cd terraform; export TF_WORKSPACE=${params.USERNAME}; terraform destroy -var 'env=${params.USERNAME}' --auto-approve"
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}

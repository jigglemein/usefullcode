pipeline {
  agent any
  stages {
    stage('Terraform: Init') {
      steps {
        sh "cd terraform/provisioners/webserver; export TF_WORKSPACE=${params.USERNAME}; terraform init"
      }
    }
    stage('Terraform: Plan') {
      when {
        expression { params.ACTION == 'APPLY' }
      }
      steps {
        sh "cd terraform/provisioners/webserver; export TF_WORKSPACE=${params.USERNAME}; terraform plan -var 'env=${params.USERNAME}'"
        script {
          timeout(time: 10, unit: 'MINUTES') {
            input(id: "Deploy Gate", message: "Deploy ${params.USERNAME}?", ok: 'Deploy')
          }
        }
      }
    }
    stage('Terraform: Apply') {
      when {
        expression { params.ACTION == 'APPLY' }
      }
      steps {
        sh "cd terraform/provisioners/webserver; export TF_WORKSPACE=${params.USERNAME}; terraform apply -var 'env=${params.USERNAME}' --auto-approve"
      }
    }
    stage('Terraform: destroy') {
      when {
        expression { params.ACTION == 'DESTROY' }
      }
      steps {
        sh "cd terraform/provisioners/webserver; export TF_WORKSPACE=${params.USERNAME}; terraform destroy -var 'env=${params.USERNAME}' --auto-approve"
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}

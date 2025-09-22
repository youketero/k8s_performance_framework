properties([parameters([choice(choices: ['apply', 'delete'], description: 'Select action for fastapp application', name: 'ACTION')])])

pipeline {
    agent any
    stages {
        stage('Checkout git') {
           steps {
               echo "Downloading git repository"
               git branch: "main", url: "https://github.com/youketero/k8s_performance_framework.git"
           }
        }
        stage('Deploy/stop fastapp') {
            steps {
                sh "kubectl ${params.ACTION} -f fastapp.yaml"
            }
        }
    }
}

properties([parameters([choice(choices: ['apply', 'delete'], description: 'Select action for fastapp application', name: 'ACTION'), string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true)])])

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
                sh "kubectl ${params.ACTION} -k ./fast_api"
            }
        }
        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }
    }
}

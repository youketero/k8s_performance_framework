properties([[$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false], 
    parameters([string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true), 
    string(defaultValue: '3', description: 'Select number of replicas. By default max number is 10', name: 'SLAVESNUM', trim: true)])])

pipeline {
    agent any

    stages {
        stage('Checkout git') {
            steps {
                echo 'Downloading git repository'
                git branch: 'main', url: 'https://github.com/youketero/k8s_performance_framework.git'
            }
        }
        stage('Check replica number') {
            steps {
                script{
                    if (params.SLAVESNUM.toInteger() > 10) {
                    error("Too many replicas requested: ${params.SLAVESNUM}. Max allowed is 10.")
                    }
                }
            }
        }
        stage('Applying k6 deployment') {
            steps {
                    echo 'Applying pod set'
                    sh """
                        kubectl delete -k ./k6 --ignore-not-found=true
                        kubectl apply -k ./k6
                        kubectl -n ${params.NAMESPACE} scale deployment k6 --replicas=${params.SLAVESNUM}
                        echo "Waiting for all replicas to become Ready..."
                        kubectl -n ${params.NAMESPACE} wait deployment k6 --for=condition=Available --timeout=2m
                        """
                    echo "✅ k6 cluster is up and running:"
            }
        }
    }
}

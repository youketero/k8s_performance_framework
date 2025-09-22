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
        stage('Recreating jmeter deployment') {
            steps {
                dir('k8s_jmeter') {
                    echo 'Recreating pod set'
                    sh """
                        kubectl -n ${params.NAMESPACE} delete -f jmeter_m.yaml -f jmeter_s.yaml --ignore-not-found=true
                        kubectl -n ${params.NAMESPACE} apply -f jmeter_m.yaml
                        kubectl -n ${params.NAMESPACE} wait --for=condition=Ready pod -l jmeter_mode=master --timeout=120s
                        """
                    echo "✅ Master pod is running:"
                    sh """
                        kubectl -n ${NAMESPACE} get pods -l jmeter_mode=master -o wide
                        kubectl -n "${NAMESPACE}" apply -f jmeter_s.yaml
                        kubectl -n ${params.NAMESPACE} scale deployment jmeter-slaves --replicas=${params.SLAVESNUM}
                        echo "Waiting for all replicas to become Ready..."
                        kubectl -n ${params.NAMESPACE} wait deployment jmeter-slaves --for=condition=Available --timeout=2m
                        """
                    echo "✅ Slave pod is running:"
                }
            }
        }
    }
}

properties([[$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false], parameters([string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true)])])
    
pipeline {
    agent any
    stages {
        stage('Download git repository') {
            steps {
                echo 'Downloading git repository'
                git branch: 'main', url: 'https://github.com/youketero/k8s_performance_framework.git'
            }
        }
        stage('Stoping jmeter nodes') {
            steps {
                echo 'Stopping jmeter nodes'
                sh "kubectl delete all -l jmeter_mode=slave -n ${params.NAMESPACE} --ignore-not-found=true && kubectl delete all -l jmeter_mode=master -n ${params.NAMESPACE} --ignore-not-found=true"
            }
        }
    }
}

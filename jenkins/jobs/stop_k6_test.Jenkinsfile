properties([[$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false], 
    parameters([string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true),
    ])])

pipeline {
    agent any
    stages {
        stage('Download Git Repository') {
            steps {
                git(
                    branch: 'main',
                    url: "https://github.com/youketero/k8s_performance_framework.git"
                )
            }
        }
        stage('Stop k6 test') {
            steps {
                script{
                   def pods = sh(script: "kubectl get pod -n ${params.NAMESPACE} -l app=k6 -o jsonpath='{range.items[*]}{.metadata.name} {end}'", returnStdout: true).trim().split(" ")
                   pods.each{  pod ->
                       sh "kubectl delete pod ${pod} -n ${params.NAMESPACE}"
                   }
                }
            }
        }
        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }
    }
}
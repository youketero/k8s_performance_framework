properties([
  [$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false], 
  parameters([
    activeChoice(
      choiceType: 'PT_CHECKBOX', 
      description: 'Select needed pvc', 
      filterLength: 1, 
      filterable: false, 
      name: 'PVC', 
      randomName: 'choice-parameter-8246961420956', 
      script: groovyScript(
        fallbackScript: [classpath: [], oldScript: '', sandbox: false, script: ''], 
        script: [classpath: [], oldScript: '', sandbox: true, script: 'return["jmeter","fastapp","k6"]']
      )
    ),
    string(
      defaultValue: 'performance', 
      description: 'Select namespace from which services will be deleted', 
      name: 'NAMESPACE', 
      trim: true
    )
  ])
])

pipeline {
    agent any

    stages {
       stage('Download git repository') {
            steps {
                echo 'Downloading git repository'
                git branch: 'main', url: 'https://github.com/youketero/k8s_performance_framework.git'
            }
        }
        stage('Start clean PVC job') {
            steps {
                script{
                        params.PVC.split(",").each{pvc ->
                        echo "clearning ${pvc}"
                        sh "kubectl apply -f ${WORKSPACE}/utils/cleanpvc_${pvc}.yaml -n ${params.NAMESPACE}"
                    }
                }
            }
        }
    }
}

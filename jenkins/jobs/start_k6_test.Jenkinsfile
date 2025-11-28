properties([[$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false], 
    parameters([string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true),
    string(defaultValue: 'Fastapp.js', description: 'Select .js file that need to be executed', name: 'TEST_FILE', trim: true), 
    string(defaultValue: '10', description: 'Select number of virtual threads. Selected number will be PER SLAVE  node', name: 'THREADS', trim: true),
    string(defaultValue: '10', description: 'Fill ramp up period in sec', name: 'RAMP_UP', trim: true),
    string(defaultValue: '120', description: 'Fill test duration in sec', name: 'DURATION', trim: true),
    string(defaultValue: 'TEST_DELAY:10', description: 'Add custom parameter in format param:value separated by comma' , name: 'CUSTOM_PARAMETERS', trim: true),
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
        stage('Start k6 test') {
            steps {
                script{
                   echo "--------- Getting needed parameters ---------"
                   def pods = sh(script: "kubectl get pod -n ${params.NAMESPACE} -l app=k6 -o jsonpath='{range.items[*]}{.metadata.name} {end}'", returnStdout: true).trim().split(" ")
                   def filePath= sh(script: "find ${WORKSPACE} -name ${TEST_FILE} | head -n 1", returnStdout: true).trim()
                   echo "--------- Copying ${filePath} into ${pods} ---------"
                   def customParams = change_custom_parameter(params.CUSTOM_PARAMETERS)
                   pods.each{  pod ->
                       sh """kubectl cp -c k6 "${filePath}" -n "${params.NAMESPACE}" "${pod}:/scripts/" """
                       sh """kubectl exec -c k6 -n "${params.NAMESPACE}" "${pod}" -- /bin/sh -c "k6 run /scripts/${TEST_FILE} ${customParams} --duration ${params.DURATION}s --vus ${params.THREADS} --out csv=/k6/report_${params.TEST_FILE}_\$(date +"%F_%H%M%S").csv > /tmp/k6.log 2>&1 & wait \$!" """
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

def change_custom_parameter(custom_parameter){
    def splittedParameters = custom_parameter.split(",")
    def parameterLine = ""
    splittedParameters.each{ parameter -> 
        parameters = parameter.split(":")
        parameterLine += " -e " + parameters[0] + "=" + parameters[1]
    }
    return parameterLine
}

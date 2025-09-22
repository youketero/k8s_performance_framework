properties([[$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false], 
    parameters([string(defaultValue: 'eck-operator,elasticsearch,kibana,logstash,beat', description: 'Which service will be stopped. Values comma separated. Example: eck-operator,elasticsearch,kibana,logstash,beat', name: 'SERVICES', trim: true), 
    string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true)])])


pipeline {
    agent any
	
    stages {
        stage('Checkout git') {
            steps {
                echo 'Downloading git repository'
                git branch: 'main', url: 'https://github.com/youketero/k8s_performance_framework.git'
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    def items = params.SERVICES.tokenize(',')
					if ("eck-operator" in items) {
						echo "Deleting ECK operator and CRDs..."

						sh '''
							kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml || true
							kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml || true
						'''

						sh '''
							kubectl delete crd elasticsearches.elasticsearch.k8s.elastic.co --ignore-not-found=true
							kubectl delete crd kibanas.kibana.k8s.elastic.co --ignore-not-found=true
							kubectl delete crd beats.beat.k8s.elastic.co --ignore-not-found=true
							kubectl delete crd agents.agent.k8s.elastic.co --ignore-not-found=true
							kubectl delete crd enterprisesearches.enterprisesearch.k8s.elastic.co --ignore-not-found=true
							kubectl delete crd stackconfigpolicies.stackconfigpolicy.k8s.elastic.co --ignore-not-found=true
						'''

						echo "ECK operator removed. Stopping pipeline gracefully..."
						currentBuild.result = 'SUCCESS'
						return
					}
					items.each{ i ->
                        echo "deleting ${i}"
                        sh "kubectl delete ${i} --all -n ${params.NAMESPACE} --ignore-not-found=true"
                    }
                }
            }
        }
    }
}

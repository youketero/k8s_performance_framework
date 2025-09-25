properties([string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true)])

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
					echo "Deleting ECK operator and CRDs..."
					sh '''
						kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml || true
						kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml || true
						kubectl delete crd elasticsearches.elasticsearch.k8s.elastic.co --ignore-not-found=true
						kubectl delete crd kibanas.kibana.k8s.elastic.co --ignore-not-found=true
						kubectl delete crd beats.beat.k8s.elastic.co --ignore-not-found=true
						kubectl delete crd agents.agent.k8s.elastic.co --ignore-not-found=true
						kubectl delete crd enterprisesearches.enterprisesearch.k8s.elastic.co --ignore-not-found=true
						kubectl delete crd stackconfigpolicies.stackconfigpolicy.k8s.elastic.co --ignore-not-found=true
						'''
						echo "ECK operator removed. Stopping pipeline gracefully..."
                    sh "kubectl delete -k ./eck"
                }
            }
        }
    }

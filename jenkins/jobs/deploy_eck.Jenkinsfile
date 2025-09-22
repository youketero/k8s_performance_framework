properties([parameters([string(defaultValue: 'performance', description: 'Select namespace from which services will be deleted', name: 'NAMESPACE', trim: true)])])

pipeline {
    agent any

    stages {
        stage('Check kubectl') {
            steps {
                echo 'Checking kubectl'
                sh 'kubectl get pods -n default'
            }
        }
        stage('Checkout git') {
            steps {
                echo 'Downloading git repository'
                git branch: 'main', url: 'https://github.com/youketero/k8s_performance_framework.git'
            }
        }
		stage('Recreate namespace') {
            steps {
                script {
                    sh 'kubectl create ns ${params.NAMESPACE} || true'
                    sh 'kubectl get ns ${params.NAMESPACE}'
                }
            }
        }
        stage('Cleanup old ECK operator') {
            steps {
                script {
                    echo 'Checking if ECK operator exists...'
                    def exists = sh(script: "kubectl get ns | grep elastic-system || true", returnStdout: true).trim()
                    if (exists) {
                        echo "ECK operator detected, deleting..."
                        sh '''
                          kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml || true
                          kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml || true
                          kubectl delete ns elastic-system --ignore-not-found=true
                        '''
                        sh '''
                          kubectl delete crd elasticsearches.elasticsearch.k8s.elastic.co --ignore-not-found=true
                          kubectl delete crd kibanas.kibana.k8s.elastic.co --ignore-not-found=true
                          kubectl delete crd beats.beat.k8s.elastic.co --ignore-not-found=true
                          kubectl delete crd agents.agent.k8s.elastic.co --ignore-not-found=true
                          kubectl delete crd enterprisesearches.enterprisesearch.k8s.elastic.co --ignore-not-found=true
                          kubectl delete crd stackconfigpolicies.stackconfigpolicy.k8s.elastic.co --ignore-not-found=true
                        '''
                        echo "Old ECK operator deleted"
                    } else {
                        echo "No ECK operator found, skipping cleanup"
                    }
                    echo "Cleaning up old workloads (elasticsearch, kibana, logstash, filebeat)..."
                    sleep 10
                }
            }
        }
        stage('Deploying ECK orkestrator') {
            steps {
                echo 'deploying eck orcestrator' 
                sh 'kubectl create -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml'
                echo 'applying eck orkestrator'
                sh 'kubectl apply -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml' 
                echo 'applying ended waiting 5 seconds'
                sleep 5
                sh 'kubectl get -n elastic-system pods' 
            }
        }
        stage('Deploying elasticsearch') {
            steps {
                echo 'Deploying elasticsearch'
                dir('k8s_jmeter') {
                    sh 'kubectl apply -f elasticsearch.yaml'
                    sleep 5
                    sh 'kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n ${params.NAMESPACE} --timeout=180s'
                    echo 'Deploying ended'
                }
                script {
                    def esPassword = sh(
                        script: "kubectl get secret elasticsearch-es-elastic-user -n ${params.NAMESPACE} -o go-template='{{.data.elastic | base64decode}}'",
                        returnStdout: true
                    ).trim()
					currentBuild.description = "#${env.BUILD_NUMBER} - Elastic user: elastic; ElasticPass: ${esPassword}" 
                }
            }
        }
        stage('Deploying kibana') {
            steps {
                echo "echo"
                echo 'Deploying kibana'
                dir('k8s_jmeter') {
                    sh 'kubectl apply -f kibana.yaml'
                    sh 'kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n ${params.NAMESPACE} --timeout=180s'
                }
                echo 'Deploying ended'
            }
        }
         stage('Deploying logstash') {
            steps {
                echo "echo"
                echo 'Deploying logstash'
                dir('k8s_jmeter') {
                    sh 'kubectl apply -f logstash.yaml'
                    sh 'kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n ${params.NAMESPACE} --timeout=180s'
                }
                echo 'Deploying ended'
            }
        }
        stage('Deploying filebeat') {
            steps {
                echo "echo"
                echo 'Deploying filebeat'
                dir('k8s_jmeter') {
                    sh 'kubectl apply -f filebeat.yaml'
                    sh 'kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n ${params.NAMESPACE} --timeout=180s'
                }
                echo 'Deploying ended'
            }
        }
        stage('Deploying metricbeat') {
            steps {
                echo "echo"
                echo 'Deploying metricbeat'
                dir('k8s_jmeter') {
                    sh 'kubectl apply -f metricbeat.yaml'
                    sh 'kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n ${params.NAMESPACE} --timeout=180s'
                }
                echo 'Deploying ended'
            }
        }
    }
}

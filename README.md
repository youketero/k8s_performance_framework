🚀 k8s_performance_framework

A framework for automating deployment and performance testing in Kubernetes clusters using Jenkins, JMeter, Elastic Stack, and FastAPI.

<details>

<summary>⚡ Quick Start</summary>

### Prerequisites  
- Installed docker
- Kubernetes cluster

### Steps  
1. Clone repository	
```
git clone https://github.com/youketero/k8s_performance_framework.git && cd k8s_performance_framework
```
2. Run deploy_framework.sh file
```
./deploy_framework.sh
```
3. Navigate to Jenkins. **http://localhost:30080**  
4. Choose **start_jmeter_test job**. 1 run will always fails. During 2 run with selected parameters   
5. Open in browser Kibana address **http://localhost:32343** with credentials 📊  
user: elastic. Code below hot to get password
```
kubectl get secret elasticsearch-es-elastic-user -n performance -o go-template='{{.data.elastic | base64decode}}'
```
6. Import objects that located in dashboards folder.   
Navigate to Stack Management -> Saved objects -> Import  
7. Open imported dashboard and check metrics  

</details>

<details>

<summary> 📂 Project Structure </summary>
  
```
k8s_performance_framework/
│   README.md
│
├───eck
│   │   kustomization.yaml
│   │
│   ├───elasticsearch
│   │       deployment.yaml
│   │       sc.yaml
│   │
│   ├───filebeat
│   │       ds.yaml
│   │       fastapp-logs-pvc.yaml
│   │       jmeter-logs-pvc.yaml
│   │
│   ├───kibana
│   │   │   deployment.yaml
│   │   │
│   │   └───dashboards
│   │           kibana_objects_jmeter.ndjson
│   │
│   ├───logstash
│   │       deployment.yaml
│   │
│   └───metricbeat
│           cr.yaml
│           crb.yaml
│           ds.yaml
│           sa.yaml
│
├───fast_api
│   │   deployment.yaml
│   │   Dockerfile
│   │   kustomization.yaml
│   │   requirements.txt
│   │   svc.yaml
│   │
│   └───app
│           main.py
│
├───img
│       arhitecture_scheme.svg
│
├───jenkins
│   │   crb.yaml
│   │   deployment.yaml
│   │   Dockerfile
│   │   jenkins_casc.yaml
│   │   kustomization.yaml
│   │   plugins.txt
│   │   pvc.yaml
│   │   sa.yaml
│   │   svc.yaml
│   │
│   └───jobs
│           deploy_eck.Jenkinsfile
│           deploy_jmeter_cluster.Jenkinsfile
│           deploy_stop_fastapp.Jenkinsfile
│           start_jmeter_test.Jenkinsfile
│           stop_eck.Jenkinsfile
│           stop_jmeter_cluster.Jenkinsfile
│           stop_jmeter_test.Jenkinsfile
│
├───jmeter
│   │   Dockerfile
│   │   kustomization.yaml
│   │   master.yaml
│   │   slave.yaml
│   │   slave_svc.yaml
│   │
│   └───scripts
│       │   Fastapp.jmx
│       │   Google_basic.jmx
│       │
│       └───data
│               data.csv
│               data_nosplit.csv
│
├───namespaces
│       performance_ns.yaml
│
└───scripts
        deploy_eck.sh
        deploy_fastapp.sh
        deploy_framework_linux.sh
        deploy_framework_win.sh
        deploy_jenkins.sh
        deploy_jmeter.sh
        stop_eck.sh
        stop_fastapp.sh
        stop_jenkins.sh
        stop_jmeter.sh
```

</details>

<details>

<summary>⚙️ Services</summary>
  
| Service       | Link                    | Description                                                                   |   
| :------------ | :--------------------   | :---------------------------------------------------------------------------  | 
| Jenkins       | http://localhost:30080  | Service for automation of cluster process and test runs                       |
| Kibana        | http://localhost:32343  | Service for monitoring cluster metrics and test results                       |
| Fastapp       | http://localhost:30000  | Testing wrote using FastAPI service for load tests                            |
|               | Internal links          |                                                                               |
| ECK operator  | -                       | The ECK is a k8s operator for automating processes in k8s                     |
| Elasticserch  | http://localhost:9200   | Distributed search and analytics engine                                       |
| Logstash      | http://localhost:5044   | Service that ingests data, processes it, and ships it for storage or analysis |
| Filebeat      | -                       | Service that monitors log files or directories and forwards them              |
| Metricbeat    | -                       | Service that collects metrics like CPU, memory, disk usage etc.               |
| Jmeter master | -                       | Controller node for distributed orchestratation of JMeter test execution      |
| Jmeter slave  | -                       | Distributed Worker node  that receives instructions from the master node      |

</details>

<details>

<summary>🏃 How to Run Tests</summary>

</details>

<details>  
<summary>📝 Example of commands</summary>
   
Deploy service  

```
#Deploy ECK operator  
kubectl create -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml  
kubectl apply -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml  
# Deploy elasticsearch service  
kubectl apply -f elasticsearch.yaml  
# Other options: kibana, logstash, filebeat, metribeat, fastapp, jmeter_s, jmeter_m, jenkins  
``` 

Stop service  

```
#Stop ECK operator  
kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml  
kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml  
kubectl delete ns elastic-system  
kubectl delete crd elasticsearches.elasticsearch.k8s.elastic.co  
kubectl delete crd kibanas.kibana.k8s.elastic.co  
kubectl delete crd beats.beat.k8s.elastic.co  
kubectl delete crd agents.agent.k8s.elastic.co  
kubectl delete crd enterprisesearches.enterprisesearch.k8s.elastic.co  
kubectl delete crd stackconfigpolicies.stackconfigpolicy.k8s.elastic.co  
# Stop elasticsearch service  
kubectl delete -f elasticsearch.yaml  
# Other options: kibana, logstash, filebeat, metribeat, fastapp, jmeter_s, jmeter_m, jenkins  
``` 

Get Elasticsearh password(for kibana service)  

```
kubectl get secret elasticsearch-es-elastic-user -n performance -o go-template='{{.data.elastic | base64decode}}'
```

Run sh script  

```
# Run deploy framework script
deploy_framework_linux.sh
```

How to build own docker image for jenkins  

```
docker build -t jenkins_test:latest ./jenkins
docker tag jenkins_test:latest <your_docker_user>/jenkins-agent:k8s
docker push <your_docker_user>/jenkins-agent:k8s
```

How to build own docker image for jmeter  

```
docker build -t jmeter:latest ./jmeter
docker tag jenkins_test:latest <your_docker_user>/jmeter:k8s
docker push <your_docker_user>/jmeter:k8s
```

</details>

<details>  

<summary> 🏗️ Framework architecture</summary>  

![alt-текст](https://github.com/youketero/k8s_performance_framework/blob/main/img/arhitecture_scheme.svg "Arhitecture scheme")

</details>  

<details>  

</details>

<details>  

<summary> 🧩 Features </summary>  

Add coverage by scripts 

</details>  

<details>  

<summary> 🤖 Jenkins jobs description </summary>
   
| Name | Description | Parameters | Parameters type | Parameters description | Parameters defaults | Stages | Stages description |
| :--- | :---------- | :--------  | :-------------  |:---------------------  |:------------------  |:-----  |:------------------ |
| deploy_eck |	Job for deploying elk stack(elasticsearch, kibana, logstash, filebeat) | NAMESPACE | String | namespace where will be added new nodes | performance | Declarative: Checkout SCM | Checkout repository where located Jenkinsfiles |
| | | | | | | Check kubectl | Check that k8s exists |
| | | | | | | Checkout git  | Download needed repository |
| | | | | | | Recreate namespace  | Recreating namespace is not exists |
| | | | | | | Cleanup old ECK operator | Deleting ECK operator and elk stack if exists |
| | | | | | | Deploying ECK orkestrator  | Deploying ECK orkestrator |
| deploy_jmeter_cluster | Job for deploying jmeter cluster(master and slave nodes) | NAMESPACE | String | namespace where will be added new nodes | performance | Declarative: Checkout SCM | Checkout repository where located Jenkinsfiles |
| | | SLAVESNUM | String | number of slavees that will be deployed | 3 | Checkout git | Download needed repository|
| | | | | | | Check replica number | Checking that replica numbers is not higher that 10(default value. Added to prevent too large values) |
| | | | | | | Recreating jmeter deployment | Creating jmeter cluster with master and needed nodes |
| deploy_stop_fastapp | Job for deploying and stoping fastapi app | NAMESPACE | String | namespace where will be added new nodes | performance | Declarative: Checkout SCM | Checkout repository where located Jenkinsfiles |
| | | ACTION | Boolean | deploy or delete fastapi application | apply(delete) | Checkout git | Download needed repository |
| | | | | | | Deploy/stop fastapp | Deploying or stopping fastapi application |
| start_jmeter_test | Job for starting jmeter test | NAMESPACE | String | namespace where will be added new nodes | performance | Declarative: Checkout SCM | Checkout repository where located Jenkinsfiles | 
| | | JMX_FILE | String | Select .jmx file that need to be executed. Example path: \jmeter\scripts | Google_basic.jmx | Download Git Repository | Downloading needed repository where located .jmx file and data files(if exists). Also if data folder not empty will be added data files. Files without _nosplit in naming will be splitted through slave nodes equally |
| | | THREADS | String | Select number of virtual threads. Selected number will be PER SLAVE node | 10 | Start jmeter test | Starting jmeter test with selected parameters |
| | | RAMP_UP |	String | RAMP_UP | 10 | Cleanup | Clean workspace folder on Jenkins pod |
| | | DURATION | String | Fill test duration in sec | 10 | | |
| | | CUSTOM_PARAMETERS | String | Add custom parameter in format param:value separated by comma | TEST_DELAY:10 | | |		
| stop_eck | Job that stopping elk stack | NAMESPACE | String | namespace where will be added new nodes | performance | Declarative: Checkout SCM | Checkout repository where located Jenkinsfiles | 
| | | | | | | Checkout git | Download needed repository |
| | | | | | | Cleanup | Clean workspace folder on Jenkins pod |       	
| stop_jmeter_cluster | Job for stopping jmeter cluster | NAMESPACE | String | namespace where will be added new nodes | performance | Declarative: Checkout SCM | Checkout repository where located Jenkinsfiles |
| | | | | | | Download git repository | Download needed repository |
| | | | | | | Stoping jmeter nodes | Stopping master and slaves nodes |     
| stop_jmeter_test | Job for stopping jmeter test | NAMESPACE | String | namespace where will be added new nodes | performance | Declarative: Checkout SCM | Checkout repository where located Jenkinsfiles |
| | | | | | | Stop Jmeter test | Stop jmeter test |  
  
</details>  
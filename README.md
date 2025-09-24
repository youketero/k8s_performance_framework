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
2. Run deploy_framework_(win or linux).sh file
```
./deploy_framework_win.sh
```
3. Navigate to Jenkins. **http://localhost:30080**  
4. Choose **start_jmeter_test job**. 1 run will always fails. During 2 run with selected parameters   
5. Open in browser Kibana address **http://localhost:32343** with credentials 📊  
user: elastic. Code below hot to get password
```
kubectl get secret elasticsearch-es-elastic-user -n performance -o go-template='{{.data.elastic | base64decode}}'
```
6. Import objects that located in dashboards folder.   
File name is **kibana_objects_jmeter.ndjson**  
Navigate to Stack Management -> Saved objects -> Import  
7. Open imported dashboard and check metrics  

</details>

<details>

<summary> 📂 Project Structure </summary>
  
```
k8s_performance_framework/
├─ dashboards/
│  └─ kibana_objects_jmeter.ndjson
├─ fast_api/
│  ├─ app/
│  │  └─ main.py
│  ├─ Dockerfile
│  └─ requirements.txt
├─ jenkins/
│  ├─ Dockerfile
│  ├─ jenkins.yaml
│  ├─ plugins.sh
│  └─ jobs
│     └─ Jenkins jobs(.Jenkinsfile)
├─ jmeter/
│  ├─ Dockerfile
│  ├─ entrypoint.sh
│  ├─ jmeter.sh
│  ├─ scripts
│  │  ├─ data
│  │  └─ example scripts(.jmx)
│  └─ plugins
│     └─ lib
├─ deploy_framework_linux.sh
├─ deploy_framework_win.sh
├─ elasticsearch.yaml
├─ fastapp.yaml
├─ filebeat.yaml
├─ jenkins.yaml
├─ jmeter_m.yaml
├─ jmeter_s.yaml
├─ logstash.yaml
├─ metricbeat.yaml
├─ namespace.yaml
└─ README.md
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
# Run deploy script on win using powershell  
./deploy_framework_win.sh
# Run deploy script on linux  
deploy_framework_linux.sh
```
</details>

<details>  

<summary> 🏗️ Framework architecture</summary>  

![alt-текст](https://github.com/youketero/k8s_performance_framework/blob/main/img/arhitecture.svg "Arhitecture scheme")

</details>  

📝 Jenkins jobs description

📄 License
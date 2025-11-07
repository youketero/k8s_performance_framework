🚀 k8s_performance_framework

A framework for automating deployment and performance testing in Kubernetes clusters using Jenkins, JMeter, Elastic Stack, and FastAPI.

<details>

<summary>⚡ Quick Start</summary>

### Prerequisites  
- Installed docker
- Kubernetes cluster
- On Windows installed WSL(Ubuntu latest for example). Also select in docker /settings/resourses/wsl integration/enable integration with selected linux distro

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
# Deploy elasticsearch service for jmeter setup
kubectl apply -k ./eck/overlays/jmeter  
# Other options: kibana, logstash, filebeat, metribeat, fastapp, jmeter_s, jmeter_m, jenkins  
``` 

Stop service  

```
#Stop ECK operator  
kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml
kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml
kubectl delete crd elasticsearches.elasticsearch.k8s.elastic.co --ignore-not-found=true
kubectl delete crd kibanas.kibana.k8s.elastic.co --ignore-not-found=true
kubectl delete crd beats.beat.k8s.elastic.co --ignore-not-found=true
kubectl delete crd agents.agent.k8s.elastic.co --ignore-not-found=true
kubectl delete crd enterprisesearches.enterprisesearch.k8s.elastic.co --ignore-not-found=true
kubectl delete crd stackconfigpolicies.stackconfigpolicy.k8s.elastic.co --ignore-not-found=true
kubectl delete -k ./eck
# Other options: kibana, logstash, filebeat, metribeat, fastapp, jmeter, jenkins  
``` 

Get Elasticsearh password(for kibana service)  

```
kubectl get secret elasticsearch-es-elastic-user -n performance -o go-template='{{.data.elastic | base64decode}}'
```

Run sh script  

```
# Run deploy framework script
./scripts/deploy_framework.sh
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

How to run jmeter test using script file  

```

```


</details>

<details>  

<summary> 🏗️ Framework architecture</summary>  

![alt-текст](https://github.com/youketero/k8s_performance_framework/blob/main/img/arhitecture_scheme.svg "Arhitecture scheme")

</details>  

<details>  

<summary> 🧩 Features </summary>  

Add coverage by scripts 

</details>  

<details>  

<details>
<summary>🤖 Jenkins Jobs Overview</summary>

---

## 🧩 **deploy_eck**

**Description:**  
Deploys the ECK (Elastic Cloud on Kubernetes) stack — includes Elasticsearch, Kibana, Logstash, and Filebeat.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace where new nodes will be deployed |

**Stages:**
1. **Checkout SCM** – Retrieve Jenkinsfile repository.  
2. **Check kubectl** – Ensure Kubernetes context is valid.  
3. **Checkout git** – Clone target repository.  
4. **Recreate namespace** – Create or refresh namespace if missing.  
5. **Cleanup old ECK operator** – Remove any existing ECK setup.  
6. **Deploy ECK orchestrator** – Deploy Elasticsearch, Kibana, Logstash, Filebeat.

---

## ⚙️ **deploy_jmeter_cluster**

**Description:**  
Deploys a JMeter cluster with master and slave nodes.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Target namespace |
| `SLAVESNUM` | String | `3` | Number of JMeter slave nodes (max 10) |

**Stages:**
1. **Checkout SCM**  
2. **Checkout git**  
3. **Check replica number**  
4. **Recreate JMeter deployment**

---

## ⚡ **deploy_stop_fastapp**

**Description:**  
Deploys or removes the FastAPI demo application.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Target namespace |
| `ACTION` | Boolean | `apply(delete)` | Whether to deploy or delete FastAPI app |

**Stages:**
1. **Checkout SCM**  
2. **Checkout git**  
3. **Deploy/stop FastApp**

---

## 🚀 **start_jmeter_test**

**Description:**  
Runs a JMeter test with given parameters and data files.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Target namespace |
| `JMX_FILE` | String | `Google_basic.jmx` | Path to test file (e.g. `jmeter/scripts`) |
| `THREADS` | String | `10` | Number of virtual users per slave |
| `RAMP_UP` | String | `10` | Ramp-up time (sec) |
| `DURATION` | String | `10` | Test duration (sec) |
| `CUSTOM_PARAMETERS` | String | `TEST_DELAY:10` | Custom params (`param:value,param2:value2`) |

**Stages:**
1. **Checkout SCM**  
2. **Download Git Repository**  
3. **Start JMeter test**  
4. **Cleanup workspace**

---

## 🛑 **stop_eck**

**Description:**  
Stops and removes ECK stack components.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Target namespace |

**Stages:**
1. **Checkout SCM**  
2. **Checkout git**  
3. **Cleanup workspace**

---

## 🧹 **stop_jmeter_cluster**

**Description:**  
Stops JMeter master and slave nodes.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace where cluster will be removed |

**Stages:**
1. **Checkout SCM**  
2. **Checkout git**  
3. **Stop JMeter nodes**

---

## ⏹️ **stop_jmeter_test**

**Description:**  
Stops an active JMeter test in the given namespace.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace containing test pods |

**Stages:**
1. **Checkout SCM**  
2. **Stop JMeter test**

---

</details>
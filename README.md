## 🚀 k8s_performance_framework

A framework for automating deployment and performance testing in Kubernetes clusters using Jenkins, JMeter, Elastic Stack, and FastAPI.

<details>

<summary>⚡ Quick Start</summary>

</details>

<details>

<summary> 📂 Project Structure </summary>

```
k8s_performance_framework/
│   LICENSE
│   README.md
│
├───eck
│   ├───base
│   │   │   kustomization.yaml
│   │   │
│   │   ├───elasticsearch
│   │   │       deployment.yaml
│   │   │       kustomization.yaml
│   │   │       sc.yaml
│   │   │
│   │   ├───filebeat
│   │   │       deployment.yaml
│   │   │       kustomization.yaml
│   │   │
│   │   ├───kibana
│   │   │   │   deployment.yaml
│   │   │   │   kustomization.yaml
│   │   │   │
│   │   │   └───dashboards
│   │   │           kibana_objects_jmeter.ndjson
│   │   │           kibana_objects_jmeter_new.ndjson
│   │   │
│   │   ├───logstash
│   │   │       deployment.yaml
│   │   │       kustomization.yaml
│   │   │
│   │   └───metricbeat
│   │           cr.yaml
│   │           crb.yaml
│   │           ds.yaml
│   │           kustomization.yaml
│   │           sa.yaml
│   │
│   └───overlays
│       ├───jmeter
│       │       fastapp-logs-pvc.yaml
│       │       filebeat-patch.yaml
│       │       jmeter-logs-pvc.yaml
│       │       kustomization.yaml
│       │       logstash-patch.yaml
│       │
│       └───k6
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
│           deploy_k6_cluster.Jenkinsfile
│           deploy_stop_fastapp.Jenkinsfile
│           start_jmeter_test.Jenkinsfile
│           stop_eck.Jenkinsfile
│           stop_jmeter_cluster.Jenkinsfile
│           stop_jmeter_test.Jenkinsfile
│           stop_k6_cluster.Jenkinsfile
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
├───k6
│       clean_pvc_job.yaml
│       deployment.yaml
│       Dockerfile
│       kustomization.yaml
│       pvc.yaml
│       svc.yaml
│       test.js
│
├───namespaces
│       performance_ns.yaml
│
└───scripts
    │   create_namespace.sh
    │   deploy_framework.sh
    │
    ├───eck
    │       deploy_eck.sh
    │       stop_eck.sh
    │
    ├───fastapp
    │       deploy_fastapp.sh
    │       stop_fastapp.sh
    │
    ├───jenkins
    │       deploy_jenkins.sh
    │       stop_jenkins.sh
    │
    ├───jmeter
    │       deploy_jmeter.sh
    │       start_jmeter_test.sh
    │       stop_jmeter.sh
    │       stop_jmeter_test.sh
    │
    └───k6
            deploy_k6.sh
            stop_k6.sh
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

### ⚙️ Quick Setup using `.sh` Scripts

#### 🧱 Prerequisites
- 🐳 Installed **Docker**
- ☸️ A **Kubernetes cluster**
- 💻 On **Windows** — installed **WSL** (e.g. Ubuntu latest)  
  In Docker settings → **Resources → WSL Integration** → enable integration with your Linux distro.

---

#### 🪄 Step 1. Clone the Repository
```bash
git clone https://github.com/youketero/k8s_performance_framework.git && cd k8s_performance_framework
```

#### 🚀 Step 2. Deploy the Framework (example for JMeter)
```bash
chmod +x ./scripts/deploy_framework.sh
./scripts/deploy_framework.sh jmeter
```

#### 🧩 Step 3. Start the Test
```bash
chmod +x ./scripts/jmeter/start_jmeter_test.sh
./scripts/start_jmeter_test.sh --namespace performance --jmx Google_basic.jmx --threads 10 --ramp-up 10 --duration 120 --custom "TEST_DELAY:10"
```

#### 📊 Step 4. Open Kibana to View Results
1. Get the **Elastic password** (username: `elastic`):
   ```bash
   kubectl get secret elasticsearch-es-elastic-user -n performance -o go-template='{{.data.elastic | base64decode}}'
   ```
2. Import dashboards from the `/dashboards` folder:  
   Navigate to **Stack Management → Saved Objects → Import**  
3. Open the imported **JMeter Dashboard** to view metrics.

> **Note:** Run all commands from the **repository root folder**

---

### 🧩 Quick Setup using Jenkins

#### 🧱 Prerequisites
- 🐳 Installed **Docker**
- ☸️ A **Kubernetes cluster**

---

#### 🪄 Step 1. Clone the Repository
```bash
git clone https://github.com/youketero/k8s_performance_framework.git && cd k8s_performance_framework
```

#### 🚀 Step 2. Deploy Jenkins Node
```bash
kubectl apply -k ./jenkins
```

#### 🌐 Step 3. Open Jenkins
Open in browser: [http://localhost:30080](http://localhost:30080)

#### ⚙️ Step 4. Run the Job
- Open the **start_jmeter_test** job  
- The **first run** will fail (initial setup)  
- The **second run** — choose parameters and start test

#### 📈 Step 5. Open Kibana Dashboard
Open in browser: [http://localhost:32343](http://localhost:32343)

**Credentials:**
- Username: `elastic`  
- Password:
  ```bash
  kubectl get secret elasticsearch-es-elastic-user -n performance -o go-template='{{.data.elastic | base64decode}}'
  ```

#### 📦 Step 6. Import Dashboards
- Go to **Stack Management → Saved Objects → Import**
- Select files from the `/dashboards` folder

#### 📊 Step 7. View Results
- Open **JMeter Dashboard**
- Explore metrics and performance data

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
kubectl delete -k ./eck/overlays/jmeter  
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
#In root folder

./scripts/jmeter/start_jmeter_test.sh --namespace performance --jmx ./jmeter/scripts/Google_basic.j
mx --threads 10 --ramp-up 10 --duration 120 --custom "TEST_DELAY:10"
```

How to stop jmeter test using script file  

```
./scripts/jmeter/stop_jmeter_test.sh
```

</details>

<details>  

<summary> 🏗️ Framework architecture</summary>  

![alt-текст](https://github.com/youketero/k8s_performance_framework/blob/main/img/arhitecture_scheme.svg "Arhitecture scheme")

</details>  

<details>  

<summary> 🧩 Features </summary>  

TBD

</details>  

<details>

<summary> 📋 Scripts </summary>  

Add coverage by scripts

#### eck/deploy_eck.sh
#### eck/stop_eck.sh
#### fastapp/deploy_fastapp.sh
#### fastapp/stop_fastapp.sh
#### jenkins/deploy_jenkins.sh
#### jenkins/stop_jenkins.sh
#### jmeter/deploy_jmeter.sh
#### jmeter/start_jmeter_test.sh
#### jmeter/stop_jmeter_test.sh
#### jmeter/stop_jmeter.sh
#### k6/deploy_k6.sh
#### k6/stop_k6.sh
#### utilities/clean_pvc.sh
#### create_namespace.sh
#### deploy_framework.sh


</details>  


<details>

<summary>🤖 Jenkins Jobs Overview</summary>

### 🧩 **deploy_eck**

**Description:**  
Deploys the ECK (Elastic Cloud on Kubernetes) stack — includes Elasticsearch, Kibana, Logstash, and Filebeat.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace where new nodes will be deployed |\
| `LOADTOOL` | Choice | `jmeter(k6)` | Select load tool for which eck will be deployed |

**Stages:**
1. **Checkout SCM** – Retrieve Jenkinsfile repository.  
2. **Check kubectl** – Ensure Kubernetes context is valid.  
3. **Checkout git** – Clone target repository.  
4. **Recreate namespace** – Create or refresh namespace if missing.  
5. **Cleanup old ECK operator** – Remove any existing ECK setup.  
6. **Deploy ECK orchestrator** – Deploy Elasticsearch, Kibana, Logstash, Filebeat.
7. **Cleanup workspace**

---

### ⚙️ **deploy_jmeter_cluster**

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
5. **Cleanup workspace**

---

### ⚡ **deploy_stop_fastapp**

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
4. **Cleanup workspace**

---

### 🚀 **start_jmeter_test**

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

### 🛑 **stop_eck**

**Description:**  
Stops and removes ECK stack components.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Target namespace |
| `LOADTOOL` | Choice | `jmeter(k6)` | Select load tool for which eck will be deployed |  

**Stages:**
1. **Checkout SCM**  
2. **Checkout git**  
3. **Cleanup workspace**

---

### 🧹 **stop_jmeter_cluster**

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
4. **Cleanup workspace**

---

### ⏹️ **stop_jmeter_test**

**Description:**  
Stops an active JMeter test in the given namespace.

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace containing test pods |

**Stages:**
1. **Checkout SCM**  
2. **Stop JMeter test**
3. **Cleanup workspace**

---

### 🧫 **deploy_k6_cluster**

**Description:**  
Job for deploying k6 cluster

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace containing test pods |
| `SLAVESNUM` | String | `3` | Number of JMeter slave nodes (max 10) |

**Stages:**
1. **Checkout SCM**  
2. **Check replica number**
3. **Applying k6 deployment**
4. **Cleanup workspace**

---

### ⏹️ **stop_k6_cluster**

**Description:**  
Job for stop k6 cluster

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace containing test pods |

**Stages:**
1. **Checkout SCM**  
2. **Stoping k6 nodes**
3. **Cleanup workspace**

---

### 🚀 **start_k6_test**

**Description:**  
Job for starting k6 test

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace containing test pods |
| `JMX_FILE` | String | `Fastapp.js` | Path to test file (e.g. `/scripts`) |
| `THREADS` | String | `10` | Number of virtual users per slave |
| `RAMP_UP` | String | `10` | Ramp-up time (sec) |
| `DURATION` | String | `120` | Test duration (sec) |
| `CUSTOM_PARAMETERS` | String | `TEST_DELAY:10` | Custom params (`param:value,param2:value2`) |

**Stages:**
1. **Checkout SCM**  
2. **Download Git Repository**
3. **Start k6 test**
4. **Cleanup workspace**

---

### 🧹 **stop_k6_test**

**Description:**  
Job for stop k6 test

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace containing test pods |

**Stages:**
1. **Checkout SCM**  
2. **Stop k6 test**
3. **Cleanup workspace**

---

### 🛑 **clean_pvc**

**Description:**  
Job for clean pvc

**Parameters:**
| Name | Type | Default | Description |
|------|------|----------|-------------|
| `NAMESPACE` | String | `performance` | Namespace containing test pods |
| `PVC` | Active choice parameter | `jmeter,fastapp,k6` | Select choice for needed pvc which will be flushed |

**Stages:**
1. **Checkout SCM**  
2. **Start clean PVC job**
3. **Cleanup workspace**

</details>

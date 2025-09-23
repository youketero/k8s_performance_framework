🚀 k8s_performance_framework

A framework for automating deployment and performance testing in Kubernetes clusters using Jenkins, JMeter, Elastic Stack, and FastAPI.

📂 Project Structure

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

⚡ Quick Start

Steps
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
5. Open in browser Kibana address **localhost:32343** with credentials(user: elastic. Code below hot to get password) 📊
```
kubectl get secret elasticsearch-es-elastic-user -n performance -o go-template='{{.data.elastic | base64decode}}'
```
6. Import objects that located in dashboards folder. File name is **kibana_objects_jmeter.ndjson**. Stack Management -> Saved objects -> Import 
7. Open imported dashboard and check metrics
⚙️ Configuration Parameters

TBD

📝 Notes

TBD

📄 License

This project is licensed under the MIT License. See the LICENSE
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
2. Setup Jenkins	Import the Jenkinsfile and configure parameters such as NAMESPACE 👷
3. Deploy components	Use YAML files to deploy:
- Elasticsearch 
- Kibana 
- Logstash 
- Filebeat 
- Metricbeat 
- FastAPI 
4. Run load tests	Configure JMeter and use templates from jmeter/ folder 🏋️‍♂️
5. Visualize metrics	Import dashboards from dashboards/ into Kibana 📊

⚙️ Configuration Parameters

TBD

📝 Notes

TBD

📄 License

This project is licensed under the MIT License. See the LICENSE
🚀 k8s_performance_framework

A framework for automating deployment and performance testing in Kubernetes clusters using Jenkins, JMeter, Elastic Stack, and FastAPI.

📂 Project Structure

| Folder / File |   Description |
| ------------- |-------------|
| Jenkinsfile CI/CD | pipeline for automated deployment and testing |
| jenkins/      | Jenkins configuration files, including agents and pipeline setup      |
| deploy_framework_linux(win).sh | deploy_framework_win.sh	Scripts for automated framework deployment on Linux 🐧 and Windows 🪟|
| jmeter/ | JMeter configurations for load testing       |
| fast_api/ | JMeter configurations for load testing     |
| dashboards/ | Templates for deploying FastAPI applications |


fast_api/	Templates for deploying FastAPI applications ⚡
dashboards/	Kibana dashboards 📊 for monitoring

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
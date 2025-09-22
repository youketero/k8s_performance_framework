🚀 k8s_performance_framework

A framework for automating deployment and performance testing in Kubernetes clusters using Jenkins, JMeter, Elastic Stack, and FastAPI.

📂 Project Structure
Folder / File	Description
Jenkinsfile	CI/CD pipeline for automated deployment and testing
jenkins/	Jenkins configuration files, including agents and pipeline setup
jmeter/	JMeter configurations for load testing 🟢
fast_api/	Templates for deploying FastAPI applications ⚡
dashboards/	Kibana dashboards 📊 for monitoring
deploy_framework_linux.sh / deploy_framework_win.sh	Scripts for automated framework deployment on Linux 🐧 and Windows 🪟

⚡ Quick Start
Step	Command / Action
1. Clone repository	
```
git clone https://github.com/youketero/k8s_performance_framework.git && cd k8s_performance_framework
```
2. Setup Jenkins	Import the Jenkinsfile and configure parameters such as NAMESPACE 👷
3. Deploy components	Use YAML files to deploy:
- Elasticsearch 🟠
- Kibana 🔵
- Logstash 🟣
- Filebeat 🟡
- Metricbeat 🟢
- FastAPI ⚡
4. Run load tests	Configure JMeter and use templates from jmeter/ folder 🏋️‍♂️
5. Visualize metrics	Import dashboards from dashboards/ into Kibana 📊

⚙️ Configuration Parameters

NAMESPACE – Kubernetes namespace for deployment 🌐

JENKINS_URL – URL of your Jenkins server 🖥️

KUBERNETES_CONTEXT – Kubernetes context for connecting to your cluster ☸️

📝 Notes

All components are designed to work in a Kubernetes cluster ☸️

Ensure your Jenkins agent has kubectl access to the target cluster 🔑

Secrets and passwords for Elasticsearch are automatically retrieved during the pipeline 🔐

📄 License

This project is licensed under the MIT License. See the LICENSE
# AWS Prometheus Grafana Monitoring Project

## Project Overview

This project is an end-to-end AWS infrastructure monitoring and observability platform built using Terraform, Prometheus, Grafana, Docker, and Linux. The goal of the project was to simulate a real-world Cloud/DevOps engineering environment where infrastructure is provisioned entirely through Infrastructure as Code (IaC), applications are deployed automatically, system observability is implemented using industry-standard monitoring tools, and infrastructure lifecycle management follows production-style engineering workflows.

The project provisions AWS infrastructure from scratch using Terraform, deploys a containerized application on Amazon EC2, installs monitoring agents, configures Prometheus to scrape infrastructure metrics, and visualizes real-time telemetry using Grafana dashboards.

This project demonstrates practical hands-on experience in:

- AWS Infrastructure Provisioning
- Terraform Infrastructure as Code
- Remote Terraform State Management
- Linux Server Automation
- Docker Container Deployment
- Prometheus Metrics Collection
- Grafana Dashboard Visualization
- Node Exporter Monitoring
- EC2 Security Hardening
- DevOps Troubleshooting
- Infrastructure Lifecycle Management

---

## Architecture

The environment is designed using a two-layer Terraform deployment model:

### Bootstrap Layer
Responsible for provisioning Terraform backend infrastructure.

Resources created:

- Amazon S3 bucket for Terraform remote state storage
- Amazon DynamoDB table for Terraform state locking

Purpose:

- centralized Terraform state storage
- state versioning
- collaboration readiness
- protection against concurrent Terraform modifications

---

### Main Infrastructure Layer
Responsible for provisioning the actual monitoring environment.

Resources created:

- AWS VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Groups
- IAM Role
- IAM Instance Profile
- EC2 Key Pair
- Application EC2 Instance
- Monitoring EC2 Instance

---

## High-Level Architecture Flow

```text
                    Internet
                        |
                        |
          --------------------------------
          |                              |
          |                              |
    App Server EC2                 Monitoring EC2
   (Docker + NGINX)          (Prometheus + Grafana)
   (Node Exporter)              (Node Exporter)
          |                              |
          |------------------------------|
                     Internal VPC Communication
                              |
                              |
                       Prometheus Scraping
                              |
                              |
                           Grafana UI


Terraform Bootstrap:
S3 Backend
DynamoDB Lock Table
```

---

## Project Structure

```text
aws-prometheus-grafana-monitoring/
│
├── bootstrap/
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── backend-resources.tf
│   └── outputs.tf
│
├── terraform/
│   ├── backend.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── vpc.tf
│   ├── subnet.tf
│   ├── internet-gateway.tf
│   ├── route-table.tf
│   ├── security-group.tf
│   ├── iam.tf
│   ├── keypair.tf
│   ├── ec2.tf
│   └── outputs.tf
│
├── scripts/
│   ├── install-app.sh
│   └── install-monitoring.sh
│
├── prometheus/
│   └── prometheus.yml
│
├── grafana/
│   └── provisioning/
│
└── README.md
```

---

## Technology Stack

### Cloud Platform
- AWS

### Infrastructure as Code
- Terraform

### Compute
- Amazon EC2

### Networking
- VPC
- Public Subnet
- Route Tables
- Internet Gateway
- Security Groups

### Monitoring / Observability
- Prometheus
- Grafana
- Node Exporter

### Containerization
- Docker
- NGINX

### OS / Automation
- Ubuntu Linux
- Bash Scripting
- cloud-init / user_data

### Terraform Backend
- Amazon S3
- Amazon DynamoDB

### Version Control
- Git
- GitHub

---

## Infrastructure Deployment Workflow

### Step 1: Bootstrap Deployment

The bootstrap Terraform stack provisions the Terraform remote backend infrastructure.

This must be deployed first because Terraform cannot use a backend that does not yet exist.

Deploy bootstrap:

```bash
cd bootstrap
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

Creates:

- S3 bucket
- DynamoDB lock table

---

### Step 2: Main Infrastructure Deployment

Deploy the main infrastructure stack:

```bash
cd ../terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

Creates:

- networking resources
- EC2 infrastructure
- IAM resources
- Docker application
- Prometheus
- Grafana
- Node Exporter

---

## Automated Provisioning

Infrastructure provisioning was fully automated using Terraform.

### Application Server Automation

Terraform user_data executed:

```text
scripts/install-app.sh
```

Tasks performed:

- update Linux packages
- install Docker
- enable Docker service
- deploy NGINX container
- create custom application landing page
- install Node Exporter
- configure Node Exporter as systemd service

---

### Monitoring Server Automation

Terraform user_data executed:

```text
scripts/install-monitoring.sh
```

Tasks performed:

- install Prometheus
- install Grafana
- install Node Exporter
- configure Prometheus scrape jobs
- configure services via systemd
- start monitoring stack automatically

---

## Monitoring Architecture

### Node Exporter

Node Exporter was installed on both EC2 instances.

Purpose:

Expose Linux host metrics to Prometheus.

Metrics collected:

- CPU utilization
- memory usage
- disk usage
- filesystem utilization
- network throughput
- process statistics
- load averages
- system uptime

Metrics endpoint example:

```text
http://10.0.1.70:9100/metrics
```

---

### Prometheus

Prometheus was configured as the metrics collection engine.

Prometheus scrape targets:

- application server Node Exporter
- monitoring server Node Exporter
- Prometheus self-monitoring

Prometheus responsibilities:

- scrape metrics
- store time-series data
- provide query engine
- feed Grafana dashboards

Prometheus UI:

```text
http://MONITORING_SERVER_IP:9090
```

---

### Grafana

Grafana was configured as the observability visualization platform.

Responsibilities:

- query Prometheus
- visualize metrics
- provide dashboards
- support operational monitoring

Imported dashboard:

```text
Node Exporter Full
Dashboard ID: 1860
```

Metrics visualized:

- CPU
- memory
- disk
- network
- filesystem
- load
- uptime

Grafana UI:

```text
http://MONITORING_SERVER_IP:3000
```

---

## Security Design

Security controls implemented:

### Security Groups

Restricted access to only trusted public IP.

Allowed ports:

Application Server:

- SSH (22)
- HTTP (80)
- Node Exporter (9100 from monitoring server only)

Monitoring Server:

- SSH (22)
- Grafana (3000)
- Prometheus (9090)
- Node Exporter (9100)

---

### SSH Key Management

Terraform generated SSH credentials using:

- TLS provider
- local provider

Benefits:

- automated key generation
- no manual SSH key creation
- reproducible deployments

Sensitive files excluded:

```text
*.pem
*.tfstate
.terraform/
```

---

## Validation and Testing

Environment validation included:

### Application Validation

Confirmed:

- NGINX container running
- application reachable via browser
- HTTP response validation

Example:

```bash
curl localhost
```

---

### Prometheus Validation

Confirmed:

Prometheus Targets page:

```text
UP
```

Targets validated:

- app-server-node
- monitoring-server-node
- prometheus

---

### Grafana Validation

Confirmed:

- Prometheus datasource connected
- dashboard imported
- live metrics displayed

---

### Infrastructure Validation

Confirmed:

- Terraform deployment successful
- EC2 instances reachable
- backend resources functional

---

## Troubleshooting Scenarios Solved

During implementation, several real-world engineering issues were resolved.

### Duplicate Terraform Resource

Issue:

Duplicate AWS key pair resource declaration.

Resolution:

Separated key management into dedicated Terraform resource definition.

---

### Terraform Template Interpolation Conflict

Issue:

Terraform interpreted Bash shell variables as Terraform template variables.

Resolution:

Corrected Bash variable syntax.

---

### Windows Path Resolution Issue

Issue:

Terraform file() function failed with Linux-style home path.

Resolution:

Replaced manual public key dependency with Terraform-generated keys.

---

### Empty Application Page

Issue:

NGINX container served blank page.

Resolution:

Validated Docker container health and corrected application content deployment.

---

### Remote Backend Dependency Ordering

Issue:

Terraform backend cannot use resources that do not yet exist.

Resolution:

Separated bootstrap backend deployment from main infrastructure deployment.

---

## Terraform Destroy Workflow

Infrastructure destruction must follow dependency order.

Destroy main infrastructure first:

```bash
cd terraform
terraform destroy -auto-approve
```

Then destroy backend:

```bash
cd ../bootstrap
terraform destroy -auto-approve
```

Reason:

Main infrastructure depends on Terraform backend.

Destroying backend first breaks state access.

---

## DevOps Skills Demonstrated

This project demonstrates practical experience in:

- Terraform
- AWS
- Infrastructure as Code
- Terraform remote backend management
- EC2 provisioning
- VPC networking
- IAM configuration
- Linux administration
- Docker deployment
- Bash automation
- Prometheus monitoring
- Grafana visualization
- Node Exporter metrics collection
- troubleshooting
- infrastructure validation
- lifecycle management
- Git/GitHub workflows

---

## Project Summary

This project demonstrates the ability to design, provision, secure, monitor, troubleshoot, and manage a production-style AWS infrastructure using modern DevOps engineering practices.

In interview terms:

> Built an AWS observability platform using Terraform to provision infrastructure, Docker to deploy applications, Prometheus to collect infrastructure telemetry, and Grafana to visualize real-time metrics while implementing secure Terraform remote state management and automated server provisioning.

---

## Future Enhancements

Planned production upgrades:

- Private Subnets
- NAT Gateway
- Application Load Balancer
- Bastion Host
- Route53 DNS
- Elastic IP
- HTTPS / TLS
- Prometheus Alertmanager
- Grafana Alerts
- Auto Scaling
- CI/CD Pipeline Integration

---

## Author

Cloud / DevOps Engineering Portfolio Project
Kolapo Omotehinse

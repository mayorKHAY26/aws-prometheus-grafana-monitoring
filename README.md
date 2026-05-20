# AWS Monitoring Project with Terraform, Prometheus, and Grafana

## Project Overview

This project deploys an AWS monitoring environment using Terraform.

Terraform creates:
- VPC
- Public subnet
- Internet gateway
- Route table
- Security groups
- EC2 application server
- EC2 monitoring server
- IAM role and instance profile
- Optional S3 backend and DynamoDB lock table

The app server runs:
- Docker
- NGINX container
- Node Exporter

The monitoring server runs:
- Prometheus
- Grafana
- Node Exporter

Prometheus scrapes server metrics, and Grafana visualizes the metrics.

---

## Architecture

```text
User
 |
 | SSH / HTTP / Grafana / Prometheus
 |
AWS VPC
 |
Public Subnet
 |
 |-- App Server EC2
 |     |-- Docker
 |     |-- NGINX App
 |     |-- Node Exporter :9100
 |
 |-- Monitoring Server EC2
       |-- Prometheus :9090
       |-- Grafana :3000
       |-- Node Exporter :9100
```

---

## Prerequisites

Install:

- Terraform
- AWS CLI
- Git Bash or Linux shell
- AWS account
- IAM user or role with permission to create EC2, VPC, IAM, S3, and DynamoDB resources

Configure AWS CLI:

```bash
aws configure
```

Create SSH key:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/monitoring-key
```

Get your public IP:

```bash
curl ifconfig.me
```

Update this line in `terraform/terraform.tfvars`:

```hcl
my_ip = "YOUR_PUBLIC_IP/32"
```

Example:

```hcl
my_ip = "203.0.113.10/32"
```

---

## Deployment

Move into Terraform folder:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Format and validate:

```bash
terraform fmt
terraform validate
```

Review plan:

```bash
terraform plan
```

Deploy:

```bash
terraform apply -auto-approve
```

---

## Outputs

Terraform will show:

- App URL
- Prometheus URL
- Grafana URL
- App server SSH command
- Monitoring server SSH command

---

## Access

Application:

```text
http://APP_PUBLIC_IP
```

Prometheus:

```text
http://MONITORING_PUBLIC_IP:9090
```

Grafana:

```text
http://MONITORING_PUBLIC_IP:3000
```

Grafana default login:

```text
Username: admin
Password: admin
```

---

## Prometheus Targets

In Prometheus, go to:

```text
Status > Targets
```

You should see:

- prometheus
- monitoring-server-node
- app-server-node

---

## Grafana Dashboard Setup

1. Open Grafana
2. Login with admin/admin
3. Change password
4. Go to Dashboards
5. Import dashboard
6. Use dashboard ID:

```text
1860
```

7. Select Prometheus datasource
8. Import

---

## Useful Commands

SSH to app server:

```bash
ssh -i ~/.ssh/monitoring-key ubuntu@APP_PUBLIC_IP
```

SSH to monitoring server:

```bash
ssh -i ~/.ssh/monitoring-key ubuntu@MONITORING_PUBLIC_IP
```

Check Docker:

```bash
docker ps
```

Check Node Exporter:

```bash
systemctl status node_exporter
```

Check Prometheus:

```bash
systemctl status prometheus
```

Check Grafana:

```bash
systemctl status grafana-server
```

Check Prometheus config:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

---

## Destroy Resources

```bash
terraform destroy -auto-approve
```

---

## Interview Summary

I built an AWS infrastructure monitoring platform using Terraform, Prometheus, Grafana, and Node Exporter. Terraform provisioned the VPC, subnet, internet gateway, route table, security groups, IAM role, and EC2 instances. One EC2 instance hosted a Dockerized NGINX application, while another EC2 instance hosted Prometheus and Grafana. Prometheus scraped system metrics from Node Exporter, and Grafana visualized CPU, memory, disk, uptime, and network metrics.

---

## Skills Demonstrated

- AWS EC2
- AWS VPC
- Terraform
- Infrastructure as Code
- Linux
- Docker
- Prometheus
- Grafana
- Node Exporter
- Security Groups
- IAM
- Monitoring and Observability

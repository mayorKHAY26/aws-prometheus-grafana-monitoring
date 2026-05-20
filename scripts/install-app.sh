#!/bin/bash
set -eux

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y docker.io curl wget

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# Run a simple NGINX app container
docker rm -f app-nginx || true
docker run -d \
  --name app-nginx \
  --restart unless-stopped \
  -p 80:80 \
  nginx:latest

# Create custom homepage inside the container
docker exec app-nginx /bin/sh -c "cat > /usr/share/nginx/html/index.html" <<'EOF'
<!DOCTYPE html>
<html>
<head>
  <title>AWS Monitoring Project</title>
</head>
<body>
  <h1>AWS Monitoring Project</h1>
  <p>This app server was deployed with Terraform.</p>
  <p>Monitoring: Prometheus + Grafana + Node Exporter</p>
</body>
</html>
EOF

# Install Node Exporter
cd /tmp
NODE_EXPORTER_VERSION="1.8.2"
wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

useradd --no-create-home --shell /usr/sbin/nologin node_exporter || true
chown node_exporter:node_exporter /usr/local/bin/node_exporter

cat > /etc/systemd/system/node_exporter.service <<'EOF'
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

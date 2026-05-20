output "app_public_ip" {
  description = "Public IP of the application server."
  value       = aws_instance.app.public_ip
}

output "app_private_ip" {
  description = "Private IP of the application server."
  value       = aws_instance.app.private_ip
}

output "monitoring_public_ip" {
  description = "Public IP of the monitoring server."
  value       = aws_instance.monitoring.public_ip
}

output "monitoring_private_ip" {
  description = "Private IP of the monitoring server."
  value       = aws_instance.monitoring.private_ip
}

output "app_url" {
  description = "Application URL."
  value       = "http://${aws_instance.app.public_ip}"
}

output "prometheus_url" {
  description = "Prometheus URL."
  value       = "http://${aws_instance.monitoring.public_ip}:9090"
}

output "grafana_url" {
  description = "Grafana URL."
  value       = "http://${aws_instance.monitoring.public_ip}:3000"
}

output "ssh_app_server" {
  description = "SSH command for app server."
  value       = "ssh -i ~/.ssh/monitoring-key ubuntu@${aws_instance.app.public_ip}"
}

output "ssh_monitoring_server" {
  description = "SSH command for monitoring server."
  value       = "ssh -i ~/.ssh/monitoring-key ubuntu@${aws_instance.monitoring.public_ip}"
}

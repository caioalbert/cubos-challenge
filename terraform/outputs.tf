output "application_url" {
  description = "URL da aplicação"
  value       = "http://localhost:8080"
}

output "prometheus_url" {
  description = "URL do Prometheus"
  value       = "http://localhost:9090"
}

output "grafana_url" {
  description = "URL do Grafana"
  value       = "http://localhost:3001"
}

output "metrics_url" {
  description = "URL das métricas"
  value       = "http://localhost:8080/metrics"
}

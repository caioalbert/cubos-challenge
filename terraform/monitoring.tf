resource "docker_container" "prometheus" {
  image = docker_image.prometheus.image_id
  name  = "prometheus"
  
  restart = "always"
  
  networks_advanced {
    name = docker_network.internal.name
  }
  
  ports {
    internal = 9090
    external = 9090
  }
  
  volumes {
    host_path      = "${path.cwd}/../monitoring/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
  }
  
  depends_on = [docker_container.backend]
}

resource "docker_container" "grafana" {
  image = docker_image.grafana.image_id
  name  = "grafana"
  
  restart = "always"
  
  networks_advanced {
    name = docker_network.external.name
  }
  
  ports {
    internal = 3000
    external = 3001
  }
  
  env = [
    "GF_SECURITY_ADMIN_PASSWORD=admin"
  ]
  
  depends_on = [docker_container.prometheus]
}

resource "docker_image" "postgres" {
  name = "postgres:15.8"
}

resource "docker_image" "backend" {
  name = "backend:latest"
  build {
    context = "../backend"
  }
}

resource "docker_image" "frontend" {
  name = "frontend:latest"
  build {
    context = "../frontend"
  }
}

resource "docker_image" "proxy" {
  name = "proxy:latest"
  build {
    context = "../proxy"
  }
}

resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

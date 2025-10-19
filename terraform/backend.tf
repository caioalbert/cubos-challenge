resource "docker_container" "backend" {
  image = docker_image.backend.image_id
  name  = "backend"
  
  restart = "always"
  
  networks_advanced {
    name = docker_network.internal.name
  }
  
  env = [
    "PORT=3000",
    "DB_HOST=database",
    "DB_PORT=5432",
    "DB_USER=${var.db_user}",
    "DB_PASS=${var.db_password}",
    "DB_NAME=${var.db_name}"
  ]
  
  healthcheck {
    test         = ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/api"]
    interval     = "30s"
    timeout      = "10s"
    start_period = "60s"
    retries      = 3
  }
  
  depends_on = [docker_container.database]
}

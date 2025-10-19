resource "docker_container" "database" {
  image = docker_image.postgres.image_id
  name  = "database"
  
  restart = "always"
  
  networks_advanced {
    name = docker_network.internal.name
  }
  
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
  
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  
  volumes {
    host_path      = "${path.cwd}/../sql/script.sql"
    container_path = "/docker-entrypoint-initdb.d/script.sql"
  }
}

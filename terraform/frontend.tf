resource "docker_container" "frontend" {
  image = docker_image.frontend.image_id
  name  = "frontend"
  
  restart = "always"
  
  networks_advanced {
    name = docker_network.external.name
  }
}

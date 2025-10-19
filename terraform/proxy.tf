resource "docker_container" "proxy" {
  image = docker_image.proxy.image_id
  name  = "proxy"
  
  restart = "always"
  
  networks_advanced {
    name = docker_network.external.name
  }
  
  networks_advanced {
    name = docker_network.internal.name
  }
  
  ports {
    internal = 80
    external = 8080
  }
  
  depends_on = [
    docker_container.frontend,
    docker_container.backend
  ]
}

resource "docker_network" "internal" {
  name = "internal"
}

resource "docker_network" "external" {
  name = "external"
}

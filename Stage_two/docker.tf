provider "docker" {}

resource "docker_network" "private_network" {
  name = "my_private_network"
  ipam_config {
    subnet = "172.30.0.0/16"

  }
}

# Pulls the  image
resource "docker_image" "images" {
  count = length(var.docker_images)
  name = var.docker_images[count.index]
}


# Create a container
resource "docker_container" "container" {
  count = length(docker_image.images)
  image = docker_image.images[count.index].name
  name  = "container-${count.index}"
  networks_advanced{
    name = docker_network.private_network.name
  }
}

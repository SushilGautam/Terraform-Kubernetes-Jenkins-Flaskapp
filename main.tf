terraform {
  required_providers {
    docker = {
      source = "terraform-providers/docker"
    }
  }
}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "flaskapp" {
  name         = "sushilgautam/final_flask_image:latest"
  keep_locally = true
}

resource "docker_container" "flaskapp" {
  image = docker_image.flaskapp.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 9000
  }
}



terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "kafka_network" {
  name = "kafka_network"
}

resource "docker_image" "zookeeper_image" {
  name = "confluentinc/cp-zookeeper:latest"
}

resource "docker_container" "zookeeper" {
  name  = "zookeeper"
  image = docker_image.zookeeper_image.name
  ports {
    internal = 2181
    external = 2181
  }
  env = ["ZOOKEEPER_CLIENT_PORT=2181", "ZOOKEEPER_TICK_TIME=2000"]
  networks_advanced {
    name = docker_network.kafka_network.name
  }
}
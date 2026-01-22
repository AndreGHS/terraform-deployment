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

/*setup zookeeper docker image*/
resource "docker_image" "zookeeper_image" {
  name = "confluentinc/cp-zookeeper:latest"
}

#setup zookeeper container
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

#setup kafka docker image

resource "docker_image" "kafka_image" {
  name = "confluentinc/cp-kafka:latest"
}

resource "docker_container" "kafka" {
  name  = "kafka"
  image = docker_image.kafka_image.name
  ports {
    internal = 9092
    external = 9092
  }
  env = ["KAFKA_BROKER_ID=1", "KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181",
    "KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092",
    "KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092",
  "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1"]

  networks_advanced {
    name = docker_network.kafka_network.name
  }
}


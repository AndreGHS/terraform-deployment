terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    kafka = {
      source = "Mongey/kafka"
      version = "~> 0.7"
    }
  }
}

provider "docker" {}

provider "kafka" {
  bootstrap_servers = ["localhost:9092"]
  ca_cert           = file("../secrets/ca.crt")
  client_cert       = file("../secrets/terraform-cert.pem")
  client_key        = file("../secrets/terraform.pem")
  tls_enabled       = true
  timeout = 30
}

resource "kafka_topic" "test" {
  name = "test-events"
  replication_factor = 1
  partitions = 3  
}
/*
resource "docker_network" "kafka_network" {
  name = "kafka_network"
}


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
}*/


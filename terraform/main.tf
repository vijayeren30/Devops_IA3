terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  # For Windows, Docker Desktop usually uses this default socket:
  host = "npipe:////.//pipe//docker_engine"
}

# Pull the Docker image from GitHub Container Registry (GHCR)
resource "docker_image" "app_image" {
  name         = "ghcr.io/vijayeren30/my-devops-project:latest"
  keep_locally = true
}

# Create and run the Docker service
resource "docker_service" "app_service" {
  name = "my-web-app"

  task_spec {
    container_spec {
      # ✅ FIX: Use .name instead of .id
      image = docker_image.app_image.name

      # Optional environment variables
      env = [
        "APP_ENV=production",
        "PORT=80"
      ]
    }
  }

  endpoint_spec {
    ports {
      target_port    = 80
      published_port = 8080
      protocol       = "tcp"
      publish_mode   = "ingress"
    }
  }
}

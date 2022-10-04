terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.3"
    }
    github = {
      source  = "hashicorp/github"
      version = ">= 5.3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.39.0"
    }
  }
}

data "google_client_config" "current" {}

data "google_container_cluster" "cluster" {
  project  = var.project
  name     = var.cluster.name
  location = var.cluster.location
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.cluster.endpoint}"
    token = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
    )
  }
}

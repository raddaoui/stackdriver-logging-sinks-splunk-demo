provider "google" {
  version = "~> 2.10.0"
  project = var.project
  zone    = var.zone
}

terraform {
  required_version = ">= 0.12"
}

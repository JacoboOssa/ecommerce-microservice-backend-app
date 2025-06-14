terraform {
  backend "gcs" {
    bucket = "terraform-state-k8s-prod-beaming-pillar-461818-j7"
    prefix = "terraform/state"
  }
} 